terraform {
  //run once with commented section ("s3"), and after uncomment
  # backend "s3" {
  #   bucket         = "tf-state-backend-dexloop-2"
  #   key            = "tf-infra/terraform.tfstate"
  #   region         = "eu-west-2"
  #   dynamodb_table = "tf-state-locking-2"
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
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region

  # Make it faster by skipping some things
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}
data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.application}-${var.environment}"
  account_id  = data.aws_caller_identity.current.account_id
  tags = {
    "ENV"   = var.environment,
    "Owner" = local.account_id
  }
}

module "tf-state" {
  source           = "../../modules/tf-state-module"
  bucket_name      = "${local.name_prefix}-tf-state-backend-dexloop-2"
  dynamo_lock_name = "${local.name_prefix}-tf-state-locking-2"
}

module "s3_bucket_code_storage" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket_prefix = local.name_prefix
  force_destroy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "name" {
  source       = "../../modules/network"
  access_key   = var.aws_access_key
  secret_key   = var.aws_secret_key
  region       = var.region
  prefix       = local.name_prefix
  default_tags = local.tags
}

module "api" {
  source = "../../modules/ws-api-module"

  access_key            = var.aws_access_key
  secret_key            = var.aws_secret_key
  region                = var.region
  prefix                = local.name_prefix
  s3_bucket_id          = module.s3_bucket_code_storage.s3_bucket_id
  api_name              = "ws_api"
  connection_table_name = "ws-connections"

  api_gateway_security_group_id = module.name.api_gateway_security_group_id
  lambda_security_group_id      = module.name.lambda_security_group_id

  vpc_public_subnet_ids  = module.name.vpc_public_subnets
  vpc_private_subnet_ids = module.name.vpc_private_subnets
  integration_uri_x      = module.name.integration_uri_x
  default_tags           = local.tags
}

# module "back" {
#   source                = "../../modules/back"
#   access_key            = var.aws_access_key
#   secret_key            = var.aws_secret_key
#   region                = var.region
#   prefix                = local.name_prefix
#   s3_bucket_id          = module.s3_bucket_code_storage.s3_bucket_id
#   api_execution_arn     = module.api.execution_arn
#   api_arn               = module.api.api_arn
#   api_invoke_url        = module.api.api_invoke_url
#   connection_table_arn  = module.api.connection_table_arn
#   connection_table_name = "ws-connections"
#   default_tags = {
#     "ENV"   = var.environment,
#     "Owner" = local.account_id
#   }
# }

# module "user_setup" {
#   source         = "../../modules/create-user-module"
#   name           = "${local.name_prefix}-${var.user_name}"
#   region         = var.region
#   policy_content = file("./iam/dev1.json")
# }

# module "back" {
#   source     = "../../modules/backend-module"
#   access_key = module.user_setup.user_access_key
#   secret_key = module.user_setup.user_secret_key
#   region     = var.region

# }
