output "api_id" {
  value       = module.api_gateway.apigatewayv2_api_id
  description = "Apigateway ID"
}

output "api_url" {
  value = "${replace(module.api_gateway.default_apigatewayv2_stage_invoke_url, "wss", "https")}/"
}

output "execution_arn" {
  value       = module.api_gateway.apigatewayv2_api_execution_arn
  description = "Execution ARN"
}
