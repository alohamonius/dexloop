variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "user_name" {
  type = string
}

variable "application" {
  description = "application name"
  default     = "<replace_with_your_project_or_application_name, use short name if possible, because some resources have length limit on its name>"
}

variable "environment" {
  description = "environment name"
  default     = "<replace_with_environment_name, such as dev, svt, prod,etc. Use short name if possible, because some resources have length limit on its name>"
}

variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "intra_subnets" {
  type = list(string)
}

