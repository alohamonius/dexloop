output "ecr_miner_arn" {
  value = module.miner_ecr.repository_arn
}

output "ecr_front_arn" {
  value = module.front_ecr.repository_arn
}

output "ecr_miner_id" {
  value = module.miner_ecr.repository_registry_id
}
output "ecr_front_id" {
  value = module.front_ecr.repository_registry_id
}

output "ecr_miner_url" {
  value = module.miner_ecr.repository_url
}

output "ecr_front_url" {
  value = module.front_ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
