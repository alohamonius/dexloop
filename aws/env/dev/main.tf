terraform {
  //run once with commented section ("s3"), and after uncomment
  backend "s3" {
  }

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
  name_prefix = var.prefix
  account_id  = data.aws_caller_identity.current.account_id
  account_arn = data.aws_caller_identity.current.arn
  tags = {
    "ENV"   = var.environment,
    "Owner" = local.account_id
  }
  state_bucket_name = "tf-state-backend-dexloop-${var.environment}"
  dynamo_lock_name  = "tf-state-locking-${var.environment}"

  connection_table = "ws-connections-${var.environment}"
  ws_api_name      = "ws-api-${var.environment}"
}

module "tf-state" {
  source           = "../../modules/tf-state-module"
  bucket_name      = local.state_bucket_name
  dynamo_lock_name = local.dynamo_lock_name

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  intra_subnets   = var.intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "s3_bucket_code_storage" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket_prefix = var.prefix
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

module "eks" {
  name            = "cluster"
  source          = "../../modules/eks"
  access_key      = var.aws_access_key
  secret_key      = var.aws_secret_key
  region          = var.region
  prefix          = var.prefix
  default_tags    = local.tags
  arn_access      = local.account_arn
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  intra_subnets   = module.vpc.intra_subnets
}

module "api" {
  source = "../../modules/ws-api-module"

  access_key            = var.aws_access_key
  secret_key            = var.aws_secret_key
  region                = var.region
  prefix                = var.prefix
  s3_bucket_id          = module.s3_bucket_code_storage.s3_bucket_id
  api_name              = local.ws_api_name
  connection_table_name = local.connection_table

  default_tags = local.tags
}

module "compute" {
  source                = "../../modules/compute-module"
  access_key            = var.aws_access_key
  secret_key            = var.aws_secret_key
  region                = var.region
  prefix                = var.prefix
  s3_bucket_id          = module.s3_bucket_code_storage.s3_bucket_id
  api_execution_arn     = module.api.execution_arn
  api_arn               = module.api.api_arn
  api_invoke_url        = module.api.api_invoke_url
  connection_table_arn  = module.api.connection_table_arn
  connection_table_name = local.connection_table
  default_tags          = local.tags
}

module "user_setup" {
  source         = "../../modules/create-user-module"
  name           = "${var.prefix}-${var.user_name}"
  region         = var.region
  policy_content = file("./iam/dev1.json")
  access_key     = var.aws_access_key
  secret_key     = var.aws_secret_key
}

