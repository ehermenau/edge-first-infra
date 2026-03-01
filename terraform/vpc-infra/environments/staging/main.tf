# vpc-infra/environments/staging/main.tf

module "vpc" {
  source = "../../modules/vpc"

  # Pass your staging-specific variables here
  vpc_cidr    = "10.1.0.0/16"
  environment = "staging"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
