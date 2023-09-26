module "aws_ws_connections_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = local.connection_table_name
  hash_key = "connection_id"

  attributes = [
    {
      name = "connection_id"
      type = "S"
    }
  ]

  tags = var.default_tags
}
