# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 6.0"

#   name = "${var.prefix}-alb-sg-${var.prefix}"

#   vpc_id          = module.vpc.vpc_id
#   security_groups = [module.alb_security_group.security_group_id]
#   subnets         = module.vpc.public_subnets

#   http_tcp_listeners = [
#     {
#       port               = 80
#       protocol           = "HTTP"
#       target_group_index = 0
#       action_type        = "forward"
#     }
#   ]

#   target_groups = [
#     {
#       name_prefix = "l1-"
#       target_type = "lambda"
#     }
#   ]
# }

# module "nlb" {
#   source = "terraform-aws-modules/alb/aws"

#   name = "${var.prefix}-nlb-sg"

#   vpc_id = module.vpc.vpc_id

#   # Use `subnets` if you don't want to attach EIPs
#   # subnets = module.vpc.private_subnets

#   # Use `subnet_mapping` to attach EIPs
#   subnet_mapping = [for i, eip in aws_eip.this : { allocation_id : eip.id, subnet_id : module.vpc.private_subnets[i] }]

#   # # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
#   # access_logs = {
#   #   bucket = module.log_bucket.s3_bucket_id
#   # }

#   # TCP_UDP, UDP, TCP
#   http_tcp_listeners = [
#     {
#       port               = 81
#       protocol           = "TCP_UDP"
#       target_group_index = 0
#     },
#     {
#       port               = 82
#       protocol           = "UDP"
#       target_group_index = 1
#     },
#     {
#       port               = 83
#       protocol           = "TCP"
#       target_group_index = 2
#     },
#   ]

#   #  TLS
#   # https_listeners = [
#   #   {
#   #     port               = 84
#   #     protocol           = "TLS"
#   #     certificate_arn    = module.acm.acm_certificate_arn
#   #     target_group_index = 3
#   #   },
#   # ]

#   target_groups = [
#     {
#       name_prefix            = "tu1-"
#       backend_protocol       = "TCP_UDP"
#       backend_port           = 81
#       target_type            = "instance"
#       connection_termination = true
#       preserve_client_ip     = true
#       stickiness = {
#         enabled = true
#         type    = "source_ip"
#       }
#       tags = {
#         tcp_udp = true
#       }
#     },
#     {
#       name_prefix      = "u1-"
#       backend_protocol = "UDP"
#       backend_port     = 82
#       target_type      = "instance"
#     },
#     {
#       name_prefix          = "t1-"
#       backend_protocol     = "TCP"
#       backend_port         = 83
#       target_type          = "ip"
#       deregistration_delay = 10
#       health_check = {
#         enabled             = true
#         interval            = 30
#         path                = "/healthz"
#         port                = "traffic-port"
#         healthy_threshold   = 3
#         unhealthy_threshold = 3
#         timeout             = 6
#       }
#     },
#     {
#       name_prefix      = "t2-"
#       backend_protocol = "TLS"
#       backend_port     = 84
#       target_type      = "instance"
#     },
#   ]

#   tags = var.default_tags
# }

resource "aws_eip" "this" {
  count = length(local.azs)

  domain = "vpc"
}

module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.prefix}-alb-sg"
  description = "ALB for example usage"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]

  egress_rules = ["all-all"]
}
