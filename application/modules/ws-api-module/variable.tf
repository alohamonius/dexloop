
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "connection_table_name" {
  description = "Name of the DynamoDB table (connections)"
  type        = string
}

variable "s3_bucket_id" {
  type = string
}

variable "api_name" {
  type = string
}

variable "prefix" {
  type = string
}

variable "default_tags" {
  type = map(string)
}


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
