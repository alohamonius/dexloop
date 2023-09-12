module "aws_ws_connections_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = var.connections_table_name
  hash_key = "connection_id"

  attributes = [
    {
      name = "connection_id"
      type = "S"
    }
  ]

  tags = {
    Terraform = "true"
  }
}
