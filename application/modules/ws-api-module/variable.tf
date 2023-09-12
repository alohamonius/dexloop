
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "connections_table_name" {
  description = "Name of the DynamoDB table (connections)"
  type        = string
  default     = "ws-connections"
}

variable "s3_bucket_id" {
  type = string
}
