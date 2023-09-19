output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

//module.vpc.private_subnets

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "api_gateway_security_group_id" {
  value = module.api_gateway_security_group.security_group_id
}

output "lambda_security_group_id" {
  value = module.lambda_security_group.security_group_id
}

output "integration_uri_x" {
  value = module.alb.http_tcp_listener_arns[0]
}
