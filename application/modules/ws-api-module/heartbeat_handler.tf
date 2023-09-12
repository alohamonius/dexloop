module "heartbeat_handler" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "aws-ws-heartbeat"
  description   = "AWS WS Test Heartbeart"
  handler       = "handler.lambda_handler"
  runtime       = "python3.8"

  publish     = true
  store_on_s3 = true
  s3_bucket   = var.s3_bucket_id
  s3_prefix   = "lambda-builds/"

  source_path = "${path.module}/lambda/heartbeat"

  allowed_triggers = {
    RunHeartbeat = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.heartbeat.arn
    }
  }

  attach_policy_statements = true
  policy_statements = {
    manage_connections = {
      effect    = "Allow",
      actions   = ["execute-api:ManageConnections"],
      resources = ["${module.api_gateway.default_apigatewayv2_stage_execution_arn}/*"]
    }
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:GetItem", "dynamodb:Scan"],
      resources = [module.aws_ws_connections_table.dynamodb_table_arn]
    }
  }
}

resource "aws_cloudwatch_event_target" "send_heartbeat" {
  arn  = module.heartbeat_handler.lambda_function_arn
  rule = aws_cloudwatch_event_rule.heartbeat.name
}
