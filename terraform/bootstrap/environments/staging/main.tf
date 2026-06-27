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
}
