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

# admin_user_arn (TF_VAR_admin_user_arn) is intentionally NOT here: it's a
# repo-level GitHub variable, not environment-scoped, but this module is
# instantiated once per environment - two independent Terraform states both
# trying to own the same repo-level resource caused a real "already exists"
# conflict on prod's apply. It lives in terraform/bootstrap/global instead,
# applied once.
