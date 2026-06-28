resource "github_repository_environment" "repo_env" {
  environment = var.environment
  repository  = var.repository
}

resource "github_actions_environment_variable" "tf_state_bucket" {
  repository    = var.repository
  environment   = var.environment
  variable_name = "TF_STATE_BUCKET"
  value         = var.state_bucket
}

resource "github_actions_environment_variable" "aws_role_arn" {
  repository    = var.repository
  environment   = var.environment
  variable_name = "AWS_ROLE_ARN"
  value         = var.aws_role_arn
}

resource "github_actions_secret" "admin_user_arn" {
  repository  = var.repository
  secret_name = "TF_VAR_admin_user_arn"
  value       = data.aws_iam_user.admin.arn
}
