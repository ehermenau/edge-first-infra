module "s3_state" {
  source      = "../../modules/s3_state"
  environment = var.environment
}

module "oidc_iam" {
  source      = "../../modules/oidc_iam"
  environment = var.environment
}
