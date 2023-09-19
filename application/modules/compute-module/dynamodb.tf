# module "aws_dynamodb_table" {
#   ource = "terraform-aws-modules/dynamodb-table/aws"
#   name  = "ChainDexTable"


#   hash_key = "GraphId"

#   attributes = [
#     {
#       name = "GraphId"
#       type = "S"
#     },
#     {
#       name = "PairId"
#       type = "S"
#     }
#   ]
# }

resource "aws_dynamodb_table" "this" {
  name             = "${var.prefix}-ChainDexTable"
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
  tags = var.default_tags
}

