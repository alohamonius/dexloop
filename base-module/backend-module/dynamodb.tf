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

resource "aws_dynamodb_table" "data" {
  name             = "ChainDexTable"
  billing_mode     = "PROVISIONED" # or "PAY_PER_REQUEST"
  read_capacity    = 5
  write_capacity   = 5
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  hash_key  = "GraphId"
  range_key = "PairId"

  attribute {
    name = "GraphId"
    type = "S"
  }

  attribute {
    name = "PairId"
    type = "S"
  }

  global_secondary_index {
    name            = "SecondaryIndexName"
    hash_key        = "PairId"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }
  tags = {
    Terraform   = true
    Environment = "dev"
  }
}

variable "connections_table_name" {
  description = "Name of the DynamoDB table (connections)"
  type        = string
  default     = "ws-connections"
}
