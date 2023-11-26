variable "managed_policies" {
  type = list(any)
  default = [
    "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs",
    "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
  ]
}

variable "name" {
  type    = string
  default = "loopdex"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "policy_content" {
  type        = string
  description = "JSON inline policy for this user"
}


variable "default_tag" {
  type    = string
  default = "terraform"
}



variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}
