resource "github_repository_environment" "repo_env" {
  environment = var.environment
  repository  = var.repository
  deployment_branch_policy {
    protected_branches     = var.protected_branches
    custom_branch_policies = false
  }
}

resource "github_actions_environment_variable" "tf_state_bucket" {
  repository    = var.repository
  environment   = var.environment
  variable_name = "TF_STATE_BUCKET"
  value         = aws_s3_bucket.state.bucket
}

resource "github_actions_environment_variable" "aws_role_arn" {
  repository    = var.repository
  environment   = var.environment
  variable_name = "AWS_ROLE_ARN"
  value         = aws_iam_role.github_ci_role.arn
}
