resource "local_file" "api_domain" {
  filename        = "lambda/heartbeat/api_url"
  file_permission = "0666"
  content         = "${replace(module.api_gateway.default_apigatewayv2_stage_invoke_url, "wss", "https")}/"
}

resource "local_file" "api_domain2" {
  filename        = "lambda/dynamo-stream-handler/api_url"
  file_permission = "0666"
  content         = "${replace(module.api_gateway.default_apigatewayv2_stage_invoke_url, "wss", "https")}/"
}

resource "local_file" "connections_table_name" {
  filename        = "lambda/dynamo-stream-handler/connection_table"
  file_permission = "0666"
  content         = var.connections_table_name
}

resource "local_file" "connections_table_name2" {
  filename        = "lambda/connection-handler/connection_table"
  file_permission = "0666"
  content         = var.connections_table_name
}
