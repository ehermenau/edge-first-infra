module "eks" {
  source = "../../modules/eks"

  environment    = var.environment
  aws_role_arn   = var.aws_role_arn
  admin_user_arn = var.admin_user_arn
}
