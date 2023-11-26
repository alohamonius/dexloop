terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.35.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

data "aws_caller_identity" "current" {}

# provider "aws" {
#   access_key = var.access_key
#   secret_key = var.secret_key
#   region     = var.region

#   # Make it faster by skipping some things
#   skip_metadata_api_check     = true
#   skip_region_validation      = true
#   skip_credentials_validation = true

#   # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
#   skip_requesting_account_id = false

# }
