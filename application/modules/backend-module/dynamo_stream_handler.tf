module "dynamo_stream_handler" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "dynamo_stream_handler"
  description   = "My awesome lambda function"
  handler       = "handler.lambda_handler"
  runtime       = "python3.8"

  publish     = true
  store_on_s3 = true

  source_path = "./lambda/dynamo-stream-handler"
  s3_bucket   = module.s3_bucket.s3_bucket_id
  s3_prefix   = "lambda-builds/"

  # cloudwatch_logs_retention_in_days = 7
  # layers = [
  #   module.lambda_layer_s3.lambda_layer_arn,
  # ]

  environment_variables = {
    Serverless = "Terraform"
  }

  tags = {
    Module = "lambda-with-layer"
  }

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:GetItem", "dynamodb:Scan"],
      resources = [aws_dynamodb_table.data.arn, module.aws_ws_connections_table.dynamodb_table_arn]
    },
    manage_connections = {
      effect    = "Allow",
      actions   = ["execute-api:ManageConnections", "execute-api:Invoke"],
      resources = ["*"] //TODO: ["${aws_apigatewayv2_stage.dev.arn}/*", "${module.api_gateway.default_apigatewayv2_stage_arn}/*"]
    }
  }

  attach_policies    = true
  number_of_policies = 1
  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
  ]

  event_source_mapping = {
    dynamodb = {
      event_source_arn  = aws_dynamodb_table.data.stream_arn
      starting_position = "LATEST"
      # destination_arn_on_failure = aws_sqs_queue.failure.arn
      filter_criteria = [
        {
          pattern = jsonencode({
            eventName : ["INSERT"]
          })
        },

      ]
    }
  }
  allowed_triggers = {
    dynamodb = {
      principal  = "dynamodb.amazonaws.com"
      source_arn = aws_dynamodb_table.data.stream_arn
    },
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
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
  #   depends_on = [aws_iam_user_policy_attachment.root_attach_policies]
}
