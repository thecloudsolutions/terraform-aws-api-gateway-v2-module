output "api_gateway_v2_api_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_api_ids
  description = "API identifiers by API Gateway definition."
}

output "api_gateway_v2_api_endpoints" {
  value       = module.api_gateway_v2.api_gateway_v2_api_endpoints
  description = "API endpoints by API Gateway definition."
}

output "api_gateway_v2_api_arns" {
  value       = module.api_gateway_v2.api_gateway_v2_api_arns
  description = "API ARNs by API Gateway definition."
}

output "api_gateway_v2_api_execution_arns" {
  value       = module.api_gateway_v2.api_gateway_v2_api_execution_arns
  description = "API execution ARN prefixes for invocation permissions."
}

output "api_gateway_v2_api_ip_address_types" {
  value       = module.api_gateway_v2.api_gateway_v2_api_ip_address_types
  description = "IP address types by API Gateway definition."
}

output "api_gateway_v2_api_tags_all" {
  value       = module.api_gateway_v2.api_gateway_v2_api_tags_all
  description = "API tags, including provider default tags."
}

output "api_gateway_v2_authorizer_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_authorizer_ids
  description = "Authorizer identifiers by API Gateway definition and logical name."
}

output "api_gateway_v2_vpc_link_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_vpc_link_ids
  description = "VPC link identifiers by API Gateway definition and logical name."
}

output "api_gateway_v2_vpc_link_arns" {
  value       = module.api_gateway_v2.api_gateway_v2_vpc_link_arns
  description = "VPC link ARNs by API Gateway definition and logical name."
}

output "api_gateway_v2_vpc_link_tags_all" {
  value       = module.api_gateway_v2.api_gateway_v2_vpc_link_tags_all
  description = "VPC link tags, including provider default tags."
}

output "api_gateway_v2_integration_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_integration_ids
  description = "Integration identifiers by API Gateway definition and logical name."
}

output "api_gateway_v2_integration_response_selection_expressions" {
  value       = module.api_gateway_v2.api_gateway_v2_integration_response_selection_expressions
  description = "Integration response selection expressions by API Gateway definition and logical name."
}

output "api_gateway_v2_route_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_route_ids
  description = "Route identifiers by API Gateway definition and logical name."
}

output "api_gateway_v2_deployment_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_deployment_ids
  description = "Deployment identifiers by API Gateway definition and logical name."
}

output "api_gateway_v2_deployment_auto_deployed" {
  value       = module.api_gateway_v2.api_gateway_v2_deployment_auto_deployed
  description = "Whether each deployment was automatically released."
}

output "api_gateway_v2_stage_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_stage_ids
  description = "Stage identifiers by API Gateway definition and logical name."
}

output "api_gateway_v2_stage_arns" {
  value       = module.api_gateway_v2.api_gateway_v2_stage_arns
  description = "Stage ARNs by API Gateway definition and logical name."
}

output "api_gateway_v2_stage_execution_arns" {
  value       = module.api_gateway_v2.api_gateway_v2_stage_execution_arns
  description = "Stage execution ARN prefixes for invocation permissions."
}

output "api_gateway_v2_stage_invoke_urls" {
  value       = module.api_gateway_v2.api_gateway_v2_stage_invoke_urls
  description = "Stage invocation URLs by API Gateway definition and logical name."
}

output "api_gateway_v2_stage_tags_all" {
  value       = module.api_gateway_v2.api_gateway_v2_stage_tags_all
  description = "Stage tags, including provider default tags."
}

output "api_gateway_v2_domain_name_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_domain_name_ids
  description = "Custom domain names by API Gateway definition and logical name."
}

output "api_gateway_v2_domain_name_arns" {
  value       = module.api_gateway_v2.api_gateway_v2_domain_name_arns
  description = "Custom domain ARNs by API Gateway definition and logical name."
}

output "api_gateway_v2_domain_name_configurations" {
  value       = module.api_gateway_v2.api_gateway_v2_domain_name_configurations
  description = "Custom domain configurations, including target domain names and hosted zone IDs."
}

output "api_gateway_v2_domain_name_api_mapping_selection_expressions" {
  value       = module.api_gateway_v2.api_gateway_v2_domain_name_api_mapping_selection_expressions
  description = "API mapping selection expressions by custom domain."
}

output "api_gateway_v2_domain_name_routing_modes" {
  value       = module.api_gateway_v2.api_gateway_v2_domain_name_routing_modes
  description = "Routing modes by custom domain."
}

output "api_gateway_v2_domain_name_tags_all" {
  value       = module.api_gateway_v2.api_gateway_v2_domain_name_tags_all
  description = "Custom domain tags, including provider default tags."
}

output "api_gateway_v2_api_mapping_ids" {
  value       = module.api_gateway_v2.api_gateway_v2_api_mapping_ids
  description = "API mapping identifiers by API Gateway definition and logical name."
}

output "acm_certificate_arns" {
  value = { for key, arn in module.acm.acm_certificate_arns :
    key => lookup(merge({}, [
      for validation_key, acm in var.acm_map : {
        "${acm.certificate_validation.certificate_custom_name != null ? acm.certificate_validation.certificate_custom_name : validation_key}" = module.acm_certificate_validation.acm_certificate_validation_arns[validation_key]
      }
      if try(acm.certificate_validation.wait_for_validation, false) && try(acm.certificate_validation.certificate_arn, null) == null
    ]...), key, arn)
  }
  description = "Certificate ARNs by ACM definition. Waits for validation when enabled."
}

output "acm_certificate_domain_validation_options" {
  value       = module.acm.acm_certificate_domain_validation_options
  description = "DNS validation records required by the managed certificates."
}

output "acm_certificate_validation_arns" {
  value = { for key, acm in var.acm_map :
    key => lookup(module.acm_certificate_validation.acm_certificate_validation_arns, key, null)
  }
  description = "Validated certificate ARNs by ACM definition."
}

output "cloudwatch_logs_log_group_arns" {
  value       = module.cloudwatch_logs.cloudwatch_logs_log_group_arns
  description = "Log group ARNs by CloudWatch Logs definition."
}

output "cloudwatch_logs_log_group_names" {
  value       = module.cloudwatch_logs.cloudwatch_logs_log_group_names
  description = "Log group names by CloudWatch Logs definition."
}

output "cloudwatch_metric_stream_arns" {
  value       = module.cloudwatch.cloudwatch_metric_stream_arns
  description = "ARNs of the metric streams."
}

output "cloudwatch_metric_stream_creation_dates" {
  value       = module.cloudwatch.cloudwatch_metric_stream_creation_dates
  description = "Creation dates of the metric streams."
}

output "cloudwatch_metric_stream_last_update_dates" {
  value       = module.cloudwatch.cloudwatch_metric_stream_last_update_dates
  description = "Last update dates of the metric streams."
}

output "cloudwatch_metric_stream_states" {
  value       = module.cloudwatch.cloudwatch_metric_stream_states
  description = "States of the metric streams."
}

output "cloudwatch_metric_stream_tags_all" {
  value       = module.cloudwatch.cloudwatch_metric_stream_tags_all
  description = "A map of tags assigned to each metric stream, including those inherited from the provider default_tags configuration block."
}

output "cloudwatch_logs_anomaly_detector_arns" {
  value       = module.cloudwatch_logs.cloudwatch_logs_anomaly_detector_arns
  description = "ARNs of the log anomaly detectors."
}

output "cloudwatch_logs_anomaly_detector_tags_all" {
  value       = module.cloudwatch_logs.cloudwatch_logs_anomaly_detector_tags_all
  description = "A map of tags assigned to each log anomaly detector, including those inherited from the provider default_tags configuration block."
}

output "cloudwatch_logs_data_protection_policy_document_jsons" {
  value       = module.cloudwatch_logs.cloudwatch_logs_data_protection_policy_document_jsons
  description = "Data protection policies rendered as JSON documents."
}

output "route53_zone_ids" {
  value       = module.route53.route53_zone_ids
  description = "Hosted zone IDs by Route 53 definition."
}

output "route53_record_names" {
  value       = module.route53.route53_record_names
  description = "Record names by Route 53 definition and logical name."
}

output "route53_record_fqdns" {
  value       = module.route53.route53_record_fqdns
  description = "Fully qualified record names by Route 53 definition and logical name."
}

output "cloudwatch_logs_delivery_source_arns" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_source_arns
  description = "The Amazon Resource Names (ARNs) of the delivery sources."
}

output "cloudwatch_logs_delivery_source_names" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_source_names
  description = "The names of the delivery sources."
}

output "cloudwatch_logs_delivery_source_services" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_source_services
  description = "The AWS services sending logs."
}

output "cloudwatch_logs_delivery_source_tags_all" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_source_tags_all
  description = "Tags assigned to the delivery sources, including provider default tags."
}

output "cloudwatch_logs_delivery_destination_arns" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_destination_arns
  description = "The Amazon Resource Names (ARNs) of the delivery destinations."
}

output "cloudwatch_logs_delivery_destination_names" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_destination_names
  description = "The names of the delivery destinations."
}

output "cloudwatch_logs_delivery_destination_tags_all" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_destination_tags_all
  description = "Tags assigned to the delivery destinations, including provider default tags."
}

output "cloudwatch_logs_delivery_arns" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_arns
  description = "The Amazon Resource Names (ARNs) of the deliveries."
}

output "cloudwatch_logs_delivery_ids" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_ids
  description = "The unique IDs of the deliveries."
}

output "cloudwatch_logs_delivery_tags_all" {
  value       = module.cloudwatch_logs.cloudwatch_logs_delivery_tags_all
  description = "Tags assigned to the deliveries, including provider default tags."
}
