
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "api_arn" {
  type = string
}
variable "api_invoke_url" {
  type = string
}
variable "connection_table_arn" {
  type = string
}
variable "connection_table_name" {
  type = string
}
variable "s3_bucket_id" {
  type = string
}
variable "api_execution_arn" {
  type = string
}

variable "prefix" {
  type = string
}

variable "default_tags" {
  type = map(string)
}
