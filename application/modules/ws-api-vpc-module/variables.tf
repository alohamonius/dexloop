
variable "vpc_public_subnet_ids" {
  type = list(string)
}
variable "vpc_private_subnet_ids" {
  type = list(string)
}

variable "lambda_security_group_id" {
  type = string
}
variable "api_gateway_security_group_id" {
  type = string
}

variable "integration_uri_x" {
  type = string
}
