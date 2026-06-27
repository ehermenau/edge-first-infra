module "s3_state" {
  source      = "../../modules/s3_state"
  environment = var.environment
}

module "oidc_iam" {
  source      = "../../modules/oidc_iam"
  environment = var.environment
}

module "git_vars" {
  source             = "../../modules/git_vars"
  environment        = var.environment
  repository         = var.repository
  protected_branches = var.protected_branches
  state_bucket       = module.s3_state.bucket_name
  aws_role_arn       = module.oidc_iam.aws_role_arn
}
