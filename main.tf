module "api_gateway_v2" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-api-gateway-v2-component.git?ref=main"

  api_gateway_v2_map = { for key, api_gateway_v2 in var.api_gateway_v2_map :
    key => merge(api_gateway_v2,
      {
        stages = { for stage_key, stage in api_gateway_v2.stages :
          stage_key => merge(stage,
            {
              access_log_settings = stage.access_log_settings != null ? merge(stage.access_log_settings,
                { destination_arn = stage.access_log_settings.destination_arn != null ? stage.access_log_settings.destination_arn : module.cloudwatch_logs.cloudwatch_logs_log_group_arns[stage.access_log_settings.log_group_custom_name] }
              ) : null
            }
          )
        }

        domain_names = { for domain_key, domain in api_gateway_v2.domain_names :
          domain_key => merge(domain,
            {
              domain_name_configuration = merge(domain.domain_name_configuration,
                {
                  certificate_arn = domain.domain_name_configuration.certificate_arn != null ? domain.domain_name_configuration.certificate_arn : lookup(merge({}, [
                    for validation_key, acm in var.acm_map : {
                      "${acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : validation_key}" = module.acm_certificate_validation.acm_certificate_validation_arns[validation_key]
                    }
                    if try(acm.certificate_validation.wait_for_validation, false) && try(acm.certificate_validation.certificate_arn, null) == null
                  ]...), domain.domain_name_configuration.certificate_custom_name, module.acm.acm_certificate_arns[domain.domain_name_configuration.certificate_custom_name])
                  ownership_verification_certificate_arn = domain.domain_name_configuration.ownership_verification_certificate_arn != null ? domain.domain_name_configuration.ownership_verification_certificate_arn : domain.domain_name_configuration.ownership_verification_certificate_custom_name != null ? lookup(merge({}, [
                    for validation_key, acm in var.acm_map : {
                      "${acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : validation_key}" = module.acm_certificate_validation.acm_certificate_validation_arns[validation_key]
                    }
                    if try(acm.certificate_validation.wait_for_validation, false) && try(acm.certificate_validation.certificate_arn, null) == null
                  ]...), domain.domain_name_configuration.ownership_verification_certificate_custom_name, module.acm.acm_certificate_arns[domain.domain_name_configuration.ownership_verification_certificate_custom_name]) : null
                }
              )
            }
          )
        }
      }
    )
  }
}

module "acm" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-acm-component.git?ref=main"

  acm_map = { for key, acm in var.acm_map :
    key => {
      certificate          = acm.certificate
      existing_certificate = acm.existing_certificate
    }
  }
}

module "acm_certificate_validation" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-acm-component.git?ref=main"

  acm_map = { for key, acm in var.acm_map :
    key =>
    {
      certificate_validation = merge(
        acm.certificate_validation,
        {
          certificate_arn = acm.certificate_validation.certificate_arn != null ? acm.certificate_validation.certificate_arn : module.acm.acm_certificate_arns[acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : key]
          region          = acm.certificate_validation.region != null ? acm.certificate_validation.region : (acm.certificate_validation.certificate_arn == null ? module.acm.acm_certificate_regions[acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : key] : null)

          validation_record_fqdns = length(acm.certificate_validation.validation_record_fqdns) > 0 ? acm.certificate_validation.validation_record_fqdns : (acm.certificate_validation.validation_records_custom_name != null ? [
            for name, fqdn in module.route53_certificate_validation.route53_record_fqdns[acm.certificate_validation.validation_records_custom_name] : fqdn
            ] : [
            for name, fqdn in lookup(module.route53_certificate_validation.route53_record_fqdns, key, {}) : fqdn
          ])
        }
      )
    }
    if try(acm.certificate_validation.wait_for_validation, false)
  }
}

module "route53_certificate_validation" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-route53-component.git?ref=main"

  route53_map = {
    for key, acm in {
      for key, acm in var.acm_map : key => merge(
        acm.certificate_validation,
        {
          domain_validation_options = acm.certificate_validation.domain_validation_options != null ? acm.certificate_validation.domain_validation_options : ((acm.certificate_validation.certificate_arn == null || acm.certificate_validation.certificate_custom_name != null) && (var.acm_map[acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : key].certificate != null ? var.acm_map[acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : key].certificate.validation_method == "DNS" : false) ? module.acm.acm_certificate_domain_validation_options[acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : key] : [])
        }
      )
      if try(acm.certificate_validation.validation_records_custom_name, null) == null && (try(acm.certificate_validation.create_route53_records, null) != null ? acm.certificate_validation.create_route53_records : (try(acm.certificate_validation.custom_zone_id, null) != null || length(try(acm.certificate_validation.custom_zone_ids, {})) > 0))
    } :
    key => {
      records = {
        for dvo in acm.domain_validation_options :
        "${key}-${regex("^(?:\\*\\.)?(.+)$", dvo.domain_name)[0]}" => {
          name    = dvo.resource_record_name
          records = [dvo.resource_record_value]
          type    = dvo.resource_record_type
          zone_id = lookup(merge(
            { for domain, zone_id in acm.custom_zone_ids : "*.${domain}" => zone_id },
            acm.custom_zone_ids
          ), dvo.domain_name, lookup(acm.custom_zone_ids, "*.${dvo.domain_name}", acm.custom_zone_id))
          ttl             = acm.record_ttl
          allow_overwrite = acm.allow_overwrite
        }

        if !contains([for option in acm.domain_validation_options : "*.${option.domain_name}"], dvo.domain_name)
      }
    }
  }
}

module "cloudwatch" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-cloudwatch-component.git?ref=main"

  cloudwatch_map = var.cloudwatch_map
}

module "cloudwatch_logs" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-cloudwatch-logs-component.git?ref=main"

  cloudwatch_logs_map = var.cloudwatch_logs_map
}

module "route53" {
  source = "git::https://github.com/thecloudsolutions/terraform-aws-route53-component.git?ref=main"

  route53_map = { for key, route53 in var.route53_map :
    key => merge(route53,
      {
        records = { for record_key, record in route53.records :
          record_key => merge(record,
            {
              alias = record.alias != null ? merge(record.alias,
                {
                  name    = record.alias.name != null ? record.alias.name : module.api_gateway_v2.api_gateway_v2_domain_name_configurations[record.alias.api_gateway_v2_custom_name][record.alias.domain_name_custom_name][0].target_domain_name
                  zone_id = record.alias.zone_id != null ? record.alias.zone_id : record.alias.domain_name_custom_name != null ? module.api_gateway_v2.api_gateway_v2_domain_name_configurations[record.alias.api_gateway_v2_custom_name][record.alias.domain_name_custom_name][0].hosted_zone_id : null
                }
              ) : null
            }
          )
        }
      }
    )
  }
}
