
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
