module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-my-vpc"
  cidr = "10.0.0.0/16"

  azs                   = local.azs
  private_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets        = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  public_subnet_names   = ["PubS1", "PubS2", "PubS3"]
  private_subnet_names  = ["PS1", "PS2", "PS3"]
  database_subnet_names = ["DB1", "DB2", "DB3"]
  enable_nat_gateway    = true
  enable_vpn_gateway    = true

  create_database_subnet_group         = false
  manage_default_network_acl           = false
  manage_default_route_table           = false
  manage_default_security_group        = false
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = var.default_tags
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = var.prefix
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service = "s3"
      tags    = var.default_tags
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = var.default_tags
    },
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecs_telemetry = {
      create              = false
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
  }
}
