module "connection_handler" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.prefix}-ws-connection-handler"
  description   = "AWS WS connection handler"
  handler       = "handler.lambda_handler"
  runtime       = "python3.8"

  publish     = true
  store_on_s3 = true
  s3_bucket   = var.s3_bucket_id
  s3_prefix   = "lambda-builds/"

  source_path = "${path.module}/lambda/connection-handler"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    manage_connections = {
      effect    = "Allow",
      actions   = ["execute-api:ManageConnections", "execute-api:Invoke"],
      resources = ["*"] //TODO: ["${aws_apigatewayv2_stage.dev.arn}/*", "${module.api_gateway.default_apigatewayv2_stage_arn}/*"]
    }
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"],
      resources = [module.aws_ws_connections_table.dynamodb_table_arn]
    }

  }
  assume_role_policy_statements = {
    account_root = {
      effect  = "Allow",
      actions = ["sts:AssumeRole"],
      principals = {
        account_principal = {
          type        = "AWS",
          identifiers = ["arn:aws:iam::${local.account_id}:user/terra"]
        }
      }
    }
  }
  tags = var.default_tags
}
