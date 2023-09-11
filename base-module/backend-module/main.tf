terraform {
  # backend "s3" {
  #   bucket         = "tf_state"
  #   key            = "./terraform.tfstate"
  #   region         = "eu-west-2"
  #   dynamodb_table = "tf_state_locks"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region

  # Make it faster by skipping some things
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false

  # shared_credentials_files = ["./.aws/credentials"]
}

data "aws_caller_identity" "current" {}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}


locals {
  account_id = data.aws_caller_identity.current.account_id
}