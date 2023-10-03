output "api_id" {
  value       = module.api_gateway.apigatewayv2_api_id
  description = "Apigateway ID"
}

output "api_invoke_url" {
  value       = replace(module.api_gateway.default_apigatewayv2_stage_invoke_url, "https", "wss")
  description = "WSS endpoint"
}

output "execution_arn" {
  value       = module.api_gateway.apigatewayv2_api_execution_arn
  description = "API Execution ARN"
}

output "api_arn" {
  value       = module.api_gateway.apigatewayv2_api_arn
  description = "API ARN"
}

output "connection_table_arn" {
  value       = module.aws_ws_connections_table.dynamodb_table_arn
  description = "Connection table ARN"
}

output "dev_invoke_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}
