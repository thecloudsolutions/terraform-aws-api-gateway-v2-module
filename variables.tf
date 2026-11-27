variable "api_gateway_v2_map" {
  type = map(object({
    api = optional(object({
      name                         = string
      protocol_type                = string
      region                       = optional(string)
      api_key_selection_expression = optional(string)
      body                         = optional(string)
      # (Optional) OpenAPI JSON or YAML. Do not also manage the same routes and integrations through their maps.
      cors_configuration = optional(object({
        allow_credentials = optional(bool)
        allow_headers     = optional(set(string))
        allow_methods     = optional(set(string))
        allow_origins     = optional(set(string))
        expose_headers    = optional(set(string))
        max_age           = optional(number)
      }))
      credentials_arn              = optional(string)
      description                  = optional(string)
      disable_execute_api_endpoint = optional(bool)
      fail_on_warnings             = optional(bool)
      ip_address_type              = optional(string)
      route_key                    = optional(string)
      route_selection_expression   = optional(string)
      target                       = optional(string)
      # (Optional) Quick-create target. AWS owns the generated integration, route and default stage.
      api_gateway_version = optional(string)
      tags                = optional(map(string))
    }))
    # (Optional) Omit api when managing children of an existing API through their explicit api_id fields.

    authorizers = optional(map(object({
      api_id                            = optional(string)
      region                            = optional(string)
      name                              = string
      authorizer_type                   = string
      authorizer_credentials_arn        = optional(string)
      authorizer_payload_format_version = optional(string)
      authorizer_result_ttl_in_seconds  = optional(number)
      authorizer_uri                    = optional(string)
      enable_simple_responses           = optional(bool)
      identity_sources                  = optional(set(string), [])
      jwt_configuration = optional(object({
        audience = optional(set(string))
        issuer   = optional(string)
      }))
      timeouts = optional(object({
        delete = optional(string)
      }))
    })), {})

    vpc_links = optional(map(object({
      name               = string
      region             = optional(string)
      security_group_ids = set(string)
      subnet_ids         = set(string)
      tags               = optional(map(string))
    })), {})

    integrations = optional(map(object({
      api_id           = optional(string)
      region           = optional(string)
      integration_type = string
      connection_id    = optional(string)
      # (Optional) Explicit VPC link ID. Takes precedence over vpc_link_custom_name.
      vpc_link_custom_name = optional(string)
      # (Optional) Key in vpc_links. Set connection_type to VPC_LINK for a private integration.
      connection_type           = optional(string)
      content_handling_strategy = optional(string)
      credentials_arn           = optional(string)
      description               = optional(string)
      integration_method        = optional(string)
      integration_subtype       = optional(string)
      integration_uri           = optional(string)
      passthrough_behavior      = optional(string)
      payload_format_version    = optional(string)
      request_parameters        = optional(map(string))
      request_templates         = optional(map(string))
      response_parameters = optional(set(object({
        status_code = string
        mappings    = map(string)
      })), [])
      template_selection_expression = optional(string)
      timeout_milliseconds          = optional(number)
      tls_config = optional(object({
        server_name_to_verify = optional(string)
      }))
    })), {})

    routes = optional(map(object({
      api_id    = optional(string)
      region    = optional(string)
      route_key = string
      target    = optional(string)
      # (Optional) Native integrations/ID target. Takes precedence over integration_custom_name.
      integration_custom_name = optional(string)
      # (Optional) Key in integrations. Multiple routes can reference the same integration.
      authorizer_id = optional(string)
      # (Optional) Explicit authorizer ID. Takes precedence over authorizer_custom_name.
      authorizer_custom_name = optional(string)
      # (Optional) Key in authorizers. Set authorization_type to JWT or CUSTOM as appropriate.
      authorization_type         = optional(string)
      authorization_scopes       = optional(set(string), [])
      api_key_required           = optional(bool)
      model_selection_expression = optional(string)
      operation_name             = optional(string)
      request_models             = optional(map(string))
      request_parameter = optional(set(object({
        request_parameter_key = string
        required              = bool
      })), [])
      route_response_selection_expression = optional(string)
    })), {})

    deployments = optional(map(object({
      api_id      = optional(string)
      region      = optional(string)
      description = optional(string)
      triggers    = optional(map(string), {})
      # (Optional) Additional redeployment triggers. The redeployment key is reserved for the managed API configuration hash.
    })), {})

    stages = optional(map(object({
      api_id      = optional(string)
      region      = optional(string)
      name        = string
      auto_deploy = optional(bool)
      # (Optional) Enable automatic HTTP API deployments. Do not combine with deployment_id or deployment_custom_name.
      deployment_id = optional(string)
      # (Optional) Explicit deployment ID. Takes precedence over deployment_custom_name.
      deployment_custom_name = optional(string)
      # (Optional) Key in deployments. Use for a stage without auto_deploy.
      access_log_settings = optional(object({
        destination_arn = optional(string)
        # (Optional) Explicit log group ARN. Takes precedence over log_group_custom_name.
        log_group_custom_name = optional(string)
        # (Optional) Key in cloudwatch_logs_map. Required when destination_arn is omitted.
        format = string
      }))
      client_certificate_id = optional(string)
      default_route_settings = optional(object({
        data_trace_enabled       = optional(bool)
        detailed_metrics_enabled = optional(bool)
        logging_level            = optional(string)
        throttling_burst_limit   = optional(number)
        throttling_rate_limit    = optional(number)
      }))
      description = optional(string)
      route_settings = optional(set(object({
        route_key                = string
        data_trace_enabled       = optional(bool)
        detailed_metrics_enabled = optional(bool)
        logging_level            = optional(string)
        throttling_burst_limit   = optional(number)
        throttling_rate_limit    = optional(number)
      })), [])
      stage_variables = optional(map(string))
      tags            = optional(map(string))
    })), {})

    domain_names = optional(map(object({
      domain_name = string
      region      = optional(string)
      domain_name_configuration = object({
        certificate_arn = optional(string)
        # (Optional) Explicit certificate ARN. Takes precedence over certificate_custom_name.
        certificate_custom_name = optional(string)
        # (Optional) Key in acm_map. Required when certificate_arn is omitted. Waits for configured certificate validation unless wait_for_validation is false.
        endpoint_type                                  = string
        security_policy                                = string
        ip_address_type                                = optional(string)
        ownership_verification_certificate_arn         = optional(string)
        ownership_verification_certificate_custom_name = optional(string)
        # (Optional) Key in acm_map used when ownership_verification_certificate_arn is omitted.
      })
      mutual_tls_authentication = optional(object({
        truststore_uri     = string
        truststore_version = optional(string)
      }))
      routing_mode = optional(string)
      timeouts = optional(object({
        create = optional(string)
        update = optional(string)
      }))
      tags = optional(map(string))
    })), {})

    api_mappings = optional(map(object({
      api_id      = optional(string)
      region      = optional(string)
      domain_name = optional(string)
      # (Optional) Explicit domain name. Takes precedence over domain_name_custom_name.
      domain_name_custom_name = optional(string)
      # (Optional) Key in domain_names. Required when domain_name is omitted.
      stage = optional(string)
      # (Optional) Explicit stage name. Takes precedence over stage_custom_name.
      stage_custom_name = optional(string)
      # (Optional) Key in stages. Required when stage is omitted.
      api_mapping_key = optional(string)
    })), {})
  }))

  description = "Keyed collection of api_gateway_v2 definitions. Child api_id fields default to the managed API; child regions default to that API region when api_id is omitted."
}

variable "acm_map" {
  type = map(object({
    certificate = optional(object({
      certificate_authority_arn = optional(string)
      certificate_body          = optional(string)
      certificate_chain         = optional(string)
      domain_name               = optional(string)
      early_renewal_duration    = optional(string)
      key_algorithm             = optional(string)
      private_key               = optional(string)
      private_key_wo            = optional(string)
      private_key_wo_version    = optional(number)
      region                    = optional(string)
      subject_alternative_names = optional(set(string))
      validation_method         = optional(string)

      options = optional(object({
        certificate_transparency_logging_preference = optional(string)
        export                                      = optional(string)
      }))

      validation_option = optional(set(object({
        domain_name       = string
        validation_domain = string
      })))

      tags = optional(map(string))
    }))

    existing_certificate = optional(object({
      domain      = optional(string)
      key_types   = optional(set(string))
      most_recent = optional(bool)
      region      = optional(string)
      statuses    = optional(list(string))
      types       = optional(list(string))

      tags = optional(map(string))
    }))

    certificate_validation = optional(object({
      allow_overwrite                = optional(bool, true)
      certificate_arn                = optional(string)
      certificate_custom_name        = optional(string)
      create_route53_records         = optional(bool)
      custom_zone_id                 = optional(string)
      custom_zone_ids                = optional(map(string), {})
      record_ttl                     = optional(number, 60)
      region                         = optional(string)
      validation_record_fqdns        = optional(set(string), [])
      validation_records_custom_name = optional(string)
      # (Optional) Key in acm_map whose generated validation records are reused.
      wait_for_validation = optional(bool, true)

      domain_validation_options = optional(set(object({
        domain_name           = string
        resource_record_name  = string
        resource_record_type  = string
        resource_record_value = string
      })))

      timeouts = optional(object({
        create = string
      }))
    }))
  }))

  default     = {}
  description = "Keyed collection of acm definitions"
}

variable "cloudwatch_map" {
  type = map(object({
    dashboard = optional(object({
      dashboard_name = string
      dashboard_body = string
      region         = optional(string)
    }))

    metric_alarms = optional(map(object({
      alarm_name                            = string
      comparison_operator                   = optional(string)
      evaluation_periods                    = optional(number)
      evaluation_interval                   = optional(number)
      metric_name                           = optional(string)
      namespace                             = optional(string)
      period                                = optional(number)
      statistic                             = optional(string)
      threshold                             = optional(number)
      threshold_metric_id                   = optional(string)
      actions_enabled                       = optional(bool)
      alarm_actions                         = optional(list(string))
      alarm_description                     = optional(string)
      datapoints_to_alarm                   = optional(number)
      dimensions                            = optional(map(string))
      insufficient_data_actions             = optional(list(string))
      ok_actions                            = optional(list(string))
      unit                                  = optional(string)
      extended_statistic                    = optional(string)
      treat_missing_data                    = optional(string)
      evaluate_low_sample_count_percentiles = optional(string)

      evaluation_criteria = optional(object({
        promql_criteria = object({
          query           = string
          pending_period  = optional(number)
          recovery_period = optional(number)
        })
      }))

      metric_query = optional(list(object({
        id          = string
        account_id  = optional(string)
        expression  = optional(string)
        label       = optional(string)
        period      = optional(number)
        return_data = optional(bool)

        metric = optional(object({
          dimensions  = optional(map(string))
          metric_name = string
          namespace   = optional(string)
          period      = number
          stat        = string
          unit        = optional(string)
        }))
      })), [])

      tags   = optional(map(string))
      region = optional(string)
    })), {})

    composite_alarms = optional(map(object({
      actions_enabled = optional(bool)

      actions_suppressor = optional(object({
        alarm            = string
        extension_period = number
        wait_period      = number
      }))

      alarm_name                = string
      alarm_rule                = string
      alarm_actions             = optional(list(string))
      alarm_description         = optional(string)
      insufficient_data_actions = optional(list(string))
      ok_actions                = optional(list(string))
      tags                      = optional(map(string))
      region                    = optional(string)
    })), {})

    metric_streams = optional(map(object({
      firehose_arn                    = string
      role_arn                        = string
      output_format                   = string
      name                            = optional(string)
      name_prefix                     = optional(string)
      include_linked_accounts_metrics = optional(bool)
      region                          = optional(string)
      tags                            = optional(map(string))

      exclude_filter = optional(set(object({
        namespace    = string
        metric_names = optional(set(string))
      })), [])

      include_filter = optional(set(object({
        namespace    = string
        metric_names = optional(set(string))
      })), [])

      statistics_configuration = optional(set(object({
        additional_statistics = set(string)
        include_metric = set(object({
          metric_name = string
          namespace   = string
        }))
      })), [])

      timeouts = optional(object({
        create = optional(string)
        update = optional(string)
        delete = optional(string)
      }))
    })), {})
  }))

  default     = {}
  description = "Keyed collection of cloudwatch definitions"
}

variable "cloudwatch_logs_map" {
  type = map(object({
    log_group = optional(object({
      name                        = optional(string)
      name_prefix                 = optional(string)
      skip_destroy                = optional(bool)
      log_group_class             = optional(string)
      retention_in_days           = optional(number)
      kms_key_id                  = optional(string)
      deletion_protection_enabled = optional(bool)
      region                      = optional(string)
      tags                        = optional(map(string))
    }))

    log_stream = optional(object({
      name           = string
      log_group_name = optional(string)
      region         = optional(string)
    }))

    account_policy = optional(object({
      policy_document             = optional(string)
      policy_document_custom_name = optional(string)
      policy_type                 = string
      policy_name                 = string
      scope                       = optional(string)
      selection_criteria          = optional(string)
      region                      = optional(string)
    }))

    destination_policies = optional(list(object({
      access_policy           = string
      destination_name        = optional(string)
      force_update            = optional(bool)
      destination_custom_name = optional(string)
      region                  = optional(string)
    })), [])

    data_protection_policy = optional(object({
      policy_document             = optional(string)
      policy_document_custom_name = optional(string)
      log_group_name              = optional(string)
      region                      = optional(string)
    }))

    destinations = optional(map(object({
      name       = string
      role_arn   = string
      target_arn = string
      tags       = optional(map(string))
      region     = optional(string)
    })), {})

    metric_filters = optional(list(object({
      name                      = string
      pattern                   = string
      log_group_name            = optional(string)
      apply_on_transformed_logs = optional(bool)
      region                    = optional(string)

      metric_transformation = object({
        name          = string
        namespace     = string
        value         = string
        default_value = optional(number)
        dimensions    = optional(map(string))
        unit          = optional(string)
      })
    })), [])

    resource_policy = optional(object({
      policy_document = string
      policy_name     = optional(string)
      resource_arn    = optional(string)
      region          = optional(string)
    }))

    subscription_filters = optional(list(object({
      name                      = string
      destination_arn           = optional(string)
      destination_custom_name   = optional(string)
      filter_pattern            = string
      log_group_name            = optional(string)
      role_arn                  = optional(string)
      distribution              = optional(string)
      apply_on_transformed_logs = optional(bool)
      emit_system_fields        = optional(set(string))
      region                    = optional(string)
    })), [])

    query_definitions = optional(list(object({
      name            = string
      query_string    = string
      log_group_names = optional(list(string))
      region          = optional(string)
    })), [])

    anomaly_detectors = optional(map(object({
      enabled                 = bool
      log_group_arn_list      = optional(list(string))
      anomaly_visibility_time = optional(number)
      detector_name           = optional(string)
      evaluation_frequency    = optional(string)
      filter_pattern          = optional(string)
      kms_key_id              = optional(string)
      region                  = optional(string)
      tags                    = optional(map(string))
    })), {})

    data_protection_policy_documents = optional(map(object({
      name           = string
      description    = optional(string)
      policy_version = optional(string)

      configuration = optional(object({
        custom_data_identifier = optional(list(object({
          name  = string
          regex = string
        })), [])
      }))

      statement = list(object({
        data_identifiers = set(string)
        sid              = optional(string)
        operation = object({
          audit = optional(object({
            findings_destination = object({
              cloudwatch_logs = optional(object({
                log_group = string
              }))
              firehose = optional(object({
                delivery_stream = string
              }))
              s3 = optional(object({
                bucket = string
              }))
            })
          }))
          deidentify = optional(object({
            mask_config = object({})
          }))
        })
      }))
    })), {})

    index_policy = optional(object({
      log_group_name  = optional(string)
      policy_document = string
      region          = optional(string)
    }))

    transformer = optional(object({
      log_group_arn = optional(string)
      region        = optional(string)

      transformer_config = list(object({
        add_keys = optional(object({
          entry = list(object({
            key                 = string
            value               = string
            overwrite_if_exists = optional(bool)
          }))
        }))
        copy_value = optional(object({
          entry = list(object({
            source              = string
            target              = string
            overwrite_if_exists = optional(bool)
          }))
        }))
        csv = optional(list(object({
          columns         = optional(list(string))
          delimiter       = optional(string)
          quote_character = optional(string)
          source          = optional(string)
        })), [])
        date_time_converter = optional(list(object({
          locale          = optional(string)
          match_patterns  = list(string)
          source          = string
          source_timezone = optional(string)
          target          = string
          target_format   = optional(string)
          target_timezone = optional(string)
        })), [])
        delete_keys = optional(list(object({
          with_keys = list(string)
        })), [])
        grok = optional(object({
          match  = string
          source = optional(string)
        }))
        list_to_map = optional(list(object({
          flatten           = optional(bool)
          flattened_element = optional(string)
          key               = string
          source            = string
          target            = optional(string)
          value_key         = optional(string)
        })), [])
        lower_case_string = optional(list(object({
          with_keys = list(string)
        })), [])
        move_keys = optional(list(object({
          entry = list(object({
            source              = string
            target              = string
            overwrite_if_exists = optional(bool)
          }))
        })), [])
        parse_cloudfront = optional(object({
          source = optional(string)
        }))
        parse_json = optional(list(object({
          destination = optional(string)
          source      = optional(string)
        })), [])
        parse_key_value = optional(list(object({
          destination         = optional(string)
          field_delimiter     = optional(string)
          key_prefix          = optional(string)
          key_value_delimiter = optional(string)
          non_match_value     = optional(string)
          overwrite_if_exists = optional(bool)
          source              = optional(string)
        })), [])
        parse_postgres = optional(object({
          source = optional(string)
        }))
        parse_route53 = optional(object({
          source = optional(string)
        }))
        parse_to_ocsf = optional(object({
          event_source = string
          ocsf_version = string
          source       = optional(string)
        }))
        parse_vpc = optional(object({
          source = optional(string)
        }))
        parse_waf = optional(object({
          source = optional(string)
        }))
        rename_keys = optional(list(object({
          entry = list(object({
            key                 = string
            rename_to           = string
            overwrite_if_exists = optional(bool)
          }))
        })), [])
        split_string = optional(list(object({
          entry = list(object({
            delimiter = string
            source    = string
          }))
        })), [])
        substitute_string = optional(list(object({
          entry = list(object({
            from   = string
            source = string
            to     = string
          }))
        })), [])
        trim_string = optional(list(object({
          with_keys = list(string)
        })), [])
        type_converter = optional(list(object({
          entry = list(object({
            key  = string
            type = string
          }))
        })), [])
        upper_case_string = optional(list(object({
          with_keys = list(string)
        })), [])
      }))
    }))

    delivery_sources = optional(map(object({
      region       = optional(string)
      name         = string
      log_type     = string
      resource_arn = string
      tags         = optional(map(string))
    })), {})

    delivery_destinations = optional(map(object({
      region                    = optional(string)
      name                      = string
      delivery_destination_type = optional(string)
      output_format             = optional(string)
      delivery_destination_configuration = optional(object({
        destination_resource_arn = optional(string)
        # (Optional) Defaults to the log group in this entry when this configuration is provided.
      }))
      tags = optional(map(string))
    })), {})

    deliveries = optional(map(object({
      region                      = optional(string)
      delivery_source_name        = optional(string)
      delivery_source_custom_name = optional(string)
      # (Optional) Key in delivery_sources. Used when delivery_source_name is omitted.
      delivery_destination_arn         = optional(string)
      delivery_destination_custom_name = optional(string)
      # (Optional) Key in delivery_destinations. Used when delivery_destination_arn is omitted.
      field_delimiter = optional(string)
      record_fields   = optional(list(string))
      s3_delivery_configuration = optional(list(object({
        enable_hive_compatible_path = optional(bool)
        suffix_path                 = optional(string)
      })))
      tags = optional(map(string))
    })), {})
  }))

  default     = {}
  description = "Keyed collection of cloudwatch logs definitions"
}

variable "route53_map" {
  type = map(object({
    zone = optional(object({
      name                        = string
      comment                     = optional(string)
      delegation_set_id           = optional(string)
      delegation_set_custom_name  = optional(string)
      enable_accelerated_recovery = optional(bool)
      force_destroy               = optional(bool)

      vpc = optional(set(object({
        vpc_id     = string
        vpc_region = optional(string)
      })))

      tags = optional(map(string))
      timeouts = optional(object({
        create = optional(string)
        update = optional(string)
        delete = optional(string)
      }))
    }))

    delegation_sets = optional(map(object({
      reference_name = optional(string)
    })), {})

    vpc_association_authorizations = optional(map(object({
      zone_id    = optional(string)
      vpc_id     = string
      vpc_region = optional(string)
      timeouts = optional(object({
        create = optional(string)
        read   = optional(string)
        delete = optional(string)
      }))
    })), {})

    zone_associations = optional(map(object({
      zone_id    = string
      vpc_id     = string
      vpc_region = optional(string)
      timeouts = optional(object({
        create = optional(string)
        delete = optional(string)
      }))
    })), {})

    cidr_collections = optional(map(object({
      name = string
    })), {})

    cidr_locations = optional(map(object({
      name                        = string
      cidr_blocks                 = set(string)
      cidr_collection_id          = optional(string)
      cidr_collection_custom_name = optional(string)
    })), {})

    health_checks = optional(map(object({
      type                            = string
      reference_name                  = optional(string)
      fqdn                            = optional(string)
      ip_address                      = optional(string)
      port                            = optional(number)
      failure_threshold               = optional(number)
      request_interval                = optional(number)
      resource_path                   = optional(string)
      search_string                   = optional(string)
      measure_latency                 = optional(bool)
      invert_healthcheck              = optional(bool)
      disabled                        = optional(bool)
      enable_sni                      = optional(bool)
      child_healthchecks              = optional(set(string))
      child_health_threshold          = optional(number)
      cloudwatch_alarm_name           = optional(string)
      cloudwatch_alarm_region         = optional(string)
      insufficient_data_health_status = optional(string)
      regions                         = optional(set(string))
      routing_control_arn             = optional(string)
      triggers                        = optional(map(string))
      tags                            = optional(map(string))
    })), {})

    dnssec = optional(object({
      hosted_zone_id             = optional(string)
      key_management_service_arn = string
      name                       = string
      status                     = optional(string)
      signing_status             = optional(string)
      key_signing_key_timeouts = optional(object({
        create = optional(string)
        update = optional(string)
        delete = optional(string)
      }))
      hosted_zone_dnssec_timeouts = optional(object({
        create = optional(string)
        update = optional(string)
        delete = optional(string)
      }))
    }))

    records = optional(map(object({
      name                     = string
      type                     = string
      zone_id                  = optional(string)
      ttl                      = optional(number)
      records                  = optional(list(string))
      set_identifier           = optional(string)
      health_check_id          = optional(string)
      health_check_custom_name = optional(string)

      alias = optional(object({
        name                       = optional(string)
        zone_id                    = optional(string)
        evaluate_target_health     = bool
        api_gateway_v2_custom_name = optional(string)
        # (Optional) Key in api_gateway_v2_map containing the target custom domain.
        domain_name_custom_name = optional(string)
        # (Optional) Key in that definition's domain_names. Explicit alias name and zone_id take precedence.
      }))

      cidr_routing_policy = optional(object({
        collection_id          = optional(string)
        collection_custom_name = optional(string)
        location_name          = optional(string)
        location_custom_name   = optional(string)
      }))

      failover_routing_policy = optional(object({
        type = string
      }))

      geolocation_routing_policy = optional(object({
        continent   = optional(string)
        country     = optional(string)
        subdivision = optional(string)
      }))

      geoproximity_routing_policy = optional(object({
        aws_region       = optional(string)
        bias             = optional(number)
        local_zone_group = optional(string)
        coordinates = optional(object({
          latitude  = string
          longitude = string
        }))
      }))

      latency_routing_policy = optional(object({
        region = string
      }))

      weighted_routing_policy = optional(object({
        weight = number
      }))

      multivalue_answer_routing_policy = optional(bool)
      allow_overwrite                  = optional(bool)
      timeouts = optional(object({
        create = optional(string)
        update = optional(string)
        delete = optional(string)
      }))
    })), {})
  }))

  default     = {}
  description = "Keyed collection of route53 definitions"
}
