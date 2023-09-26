resource "local_file" "api" {
  filename        = "${path.module}/lambda/dynamo-stream-handler/api_url"
  file_permission = "0666"
  content         = "${replace(var.api_invoke_url, "wss", "https")}/"
}
resource "local_file" "table" {
  filename        = "${path.module}/lambda/dynamo-stream-handler/connection_table"
  file_permission = "0666"
  content         = "${var.prefix}-${var.connection_table_name}"
}
