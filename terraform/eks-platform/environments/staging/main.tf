module "eks" {
  source = "../../modules/eks"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  az_count    = var.az_count
}
