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

variable "azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}



