# admin_user_arn (TF_VAR_admin_user_arn) is a repo-level GitHub Actions
# variable, not an environment-scoped one - the same admin ARN applies
# regardless of which cluster environment is being deployed. It used to
# live in the per-environment git_vars module (instantiated once each for
# staging and prod), which meant two independent Terraform states both
# tried to own the same repo-level resource - prod's apply failed with an
# "already exists" conflict once staging had created it first. Applied
# once, here, instead.
data "aws_iam_user" "admin" {
  user_name = var.admin_username
}

resource "github_actions_variable" "admin_user_arn" {
  repository    = var.repository
  variable_name = "TF_VAR_admin_user_arn"
  value         = data.aws_iam_user.admin.arn
}
