resource "local_file" "connections_table_name2" {
  filename        = "${path.module}/lambda/connection-handler/connection_table"
  file_permission = "0666"
  content         = local.connection_table_name
}
resource "local_file" "api_domain" {
  filename        = "${path.module}/lambda/heartbeat/api_url"
  file_permission = "0666"
  content         = module.api_gateway.default_apigatewayv2_stage_invoke_url
}

resource "local_file" "api_domai2" {
  filename        = "${path.module}/lambda/heartbeat/api_url2"
  file_permission = "0666"
  content         = replace(aws_apigatewayv2_stage.dev.invoke_url, "https://", "wss://")
}
