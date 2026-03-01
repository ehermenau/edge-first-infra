# environments/staging/main.tf

module "vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  az_count    = var.az_count
}
