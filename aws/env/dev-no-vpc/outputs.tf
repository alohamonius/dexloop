output "ws_api_url" {
  value       = module.api.api_invoke_url
  description = "WS API URL"
}

# output "ecr_miner_url" {
#   value       = module.eks.ecr_miner_url
#   description = "ECR miner url"
# }

# output "eks_cluster_name" {
#   value       = module.eks.eks_cluster_name
#   description = "EKS cluster name"
# }

output "data_dynamodb_table" {
  value = module.compute.dynamodb_table
}


resource "local_file" "url_for_website" {
  filename        = "../../../ws-client/public/static/ws-url"
  file_permission = "0666"
  content         = replace(aws_apigatewayv2_stage.dev.invoke_url, "https://", "wss://")
}
