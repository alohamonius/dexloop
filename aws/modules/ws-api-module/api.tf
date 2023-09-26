module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name                       = "${var.prefix}-${var.api_name}"
  description                = "My awesome AWS Websocket API Gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  create_api_domain_name = false

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  integrations = {
    "$connect" = {
      lambda_arn = module.connection_handler.lambda_function_invoke_arn
    },
    "$disconnect" = {
      lambda_arn = module.connection_handler.lambda_function_invoke_arn
    },
    "$default" = {
      lambda_arn = module.connection_handler.lambda_function_invoke_arn
    }
  }
  tags = var.default_tags
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = module.api_gateway.apigatewayv2_api_id

  name        = "dev"
  auto_deploy = true
}

resource "aws_cloudwatch_event_rule" "heartbeat" {
  name                = "${var.prefix}-aws-ws-heartbeart"
  description         = "Ping connected Websocket clients"
  schedule_expression = "rate(1 minute)"
}





resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "${var.prefix}-${random_pet.this.id}"
}
