data "aws_caller_identity" "current" {}

resource "aws_iam_user" "new_user" {
  name = var.name

  tags = {
    owner     = data.aws_caller_identity.current.account_id
    createdBy = var.default_tag
  }
}

resource "aws_iam_policy" "this" {
  name        = "execution_policy_${var.name}"
  description = "generated policy for new user"
  policy      = var.policy_content
}

resource "aws_iam_user_policy_attachment" "root_attach_policies" {
  user       = var.name
  policy_arn = aws_iam_policy.this.arn

  depends_on = [aws_iam_user.new_user]

}


resource "aws_iam_user_policy_attachment" "attach_policies" {
  for_each   = toset(var.managed_policies) # Convert the list of managed_policies to a set for uniqueness
  user       = aws_iam_user.new_user.name  # Assuming you have a resource named "aws_iam_user.new_user"
  policy_arn = each.value
  depends_on = [aws_iam_user.new_user]

}


resource "aws_iam_access_key" "new_user" {
  user = aws_iam_user.new_user.name
}
