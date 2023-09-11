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

module "tf-state" {
  source           = "./tf-state"
  bucket_name      = "tf-state-backend-dexloop-2"
  dynamo_lock_name = "tf-state-locking-2"
}

module "user_setup" {
  source         = "./user_setup"
  name           = var.user_name
  region         = var.region
  policy_content = file("./iam/dev1.json")
}

module "back" {
  source     = "./backend-module"
  access_key = module.user_setup.user_access_key
  secret_key = module.user_setup.user_secret_key
  region     = var.region

}
