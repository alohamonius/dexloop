
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "prefix" {
  type = string
}
variable "name" {
  type = string
}

variable "default_tags" {
  type = map(string)
}

variable "arn_access" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "private_subnets" {
  type = list(string)
}
variable "intra_subnets" {
  type = list(string)
}
