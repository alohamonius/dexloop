output "all_policies" {
  value = "applied arns: ${join(", ", var.managed_policies)}"
}

output "user_secret_key" {
  value     = aws_iam_access_key.new_user.secret
  sensitive = true
}

output "user_access_key" {
  value     = aws_iam_access_key.new_user.id
  sensitive = true
}
