terraform {
  //run once with commented section ("s3"), and after uncomment
  backend "s3" {
  }

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

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 4.0"

#   name = "${var.prefix}-vpc"
#   cidr = var.vpc_cidr


#   create_database_subnet_group  = false
#   manage_default_network_acl    = false
#   manage_default_route_table    = false
#   manage_default_security_group = false


#   azs             = var.azs
#   private_subnets = var.private_subnets
#   public_subnets  = var.public_subnets
#   intra_subnets   = var.intra_subnets

#   enable_nat_gateway = true
#   single_nat_gateway = true

#   enable_dns_hostnames = true
#   enable_dns_support   = true


#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }
# data "aws_security_group" "default" {
#   name   = "default"
#   vpc_id = module.vpc.vpc_id
# }


# module "vpc_endpoints" {
#   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

#   vpc_id = module.vpc.vpc_id

#   create_security_group      = true
#   security_group_name_prefix = var.prefix
#   security_group_description = "VPC endpoint security group"
#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [module.vpc.vpc_cidr_block]
#     }
#   }

#   endpoints = {
#     s3 = {
#       service = "s3"
#       tags    = var.default_tags
#     },
#     dynamodb = {
#       service         = "dynamodb"
#       service_type    = "Gateway"
#       route_table_ids = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
#       policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
#       tags            = var.default_tags
#     },
#     lambda = {
#       service             = "lambda"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc.private_subnets
#     },
#   }
# }


# data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
#   statement {
#     effect    = "Deny"
#     actions   = ["dynamodb:*"]
#     resources = ["*"]

#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }

#     condition {
#       test     = "StringNotEquals"
#       variable = "aws:sourceVpce"

#       values = [module.vpc.vpc_id]
#     }
#   }
# }


resource "aws_route53_zone" "example" {
  name = "dexloop.lol"
}

# resource "aws_route53_record" "nameservers" {
#   allow_overwrite = true
#   name            = "dexloop.lol"
#   ttl             = 3600
#   type            = "NS"
#   zone_id         = aws_route53_zone.example.zone_id

#   records = aws_route53_zone.example.name_servers
# }

# resource "aws_route53_record" "protonmail_txt" {
#   zone_id = aws_route53_zone.example.zone_id
#   name    = ""
#   type    = "TXT"
#   ttl     = 300

#   records = [
#     "protonmail-verification=<random_number>"
#   ]
# }

# resource "aws_route53_record" "protonmail_mx" {
#   zone_id = aws_route53_zone.example.zone_id
#   name    = ""
#   type    = "MX"
#   ttl     = 1800

#   records = [
#     "10 mail.protonmail.ch.",
#     "20 mailsec.protonmail.ch."
#   ]
# }


# output "elastic_ips" {
#   value       = module.vpc.nat_public_ips
#   description = "nat public ips"
# }

# output "v" {
#   value = module.vpc.
# }
