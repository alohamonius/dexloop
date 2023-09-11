
# resource "aws_api_gateway_account" "demo" {
#   cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
# }

# resource "aws_iam_role" "cloudwatch" {
#   name = "api_gateway_cloudwatch_global"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "apigateway.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# data "aws_iam_policy_document" "cloudwatch" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:DescribeLogGroups",
#       "logs:DescribeLogStreams",
#       "logs:PutLogEvents",
#       "logs:GetLogEvents",
#       "logs:FilterLogEvents",
#     ]

#     resources = ["*"]
#   }
# }
# resource "aws_iam_role_policy" "cloudwatch" {
#   name   = "default"
#   role   = aws_iam_role.cloudwatch.id
#   policy = data.aws_iam_policy_document.cloudwatch.json
# }

# resource "aws_cloudwatch_log_group" "logs" {
#   name = "aws-ws-test"
# }

# resource "aws_iam_policy" "root_user_policy" {
#   name        = "root_policies"
#   description = "root basic policies"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "lambda:UpdateFunctionCode",
#           "lambda:UpdateFunctionConfiguration",
#           "lambda:TagResource",
#           "lambda:AddPermission",
#           "lambda:RemovePermission",
#           "lambda:PublishVersion"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:DescribeLogGroups",
#           "logs:DescribeLogStreams",
#           "logs:PutLogEvents",
#           "logs:GetLogEvents",
#           "logs:FilterLogEvents",
#           "logs:DeleteLogGroup",
#           "logs:PutRetentionPolicy",
#           "logs:ListTagsLogGroup",
#           "logs:TagResource"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow",
#         Action = [
#           "apigateway:POST",
#           "apigateway:DELETE",
#           "apigateway:GET",
#           "apigateway:TagResource",
#           "apigateway:UpdateRestApiPolicy",
#           "apigateway:PATCH"
#         ],
#         Resource = "*"
#       },
#       {
#         Effect   = "Allow",
#         Action   = ["events:*"],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_user_policy_attachment" "root_attach_policies" {
#   user       = "terra"
#   policy_arn = aws_iam_policy.root_user_policy.arn
# }
