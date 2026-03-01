# environments/staging/outputs.tf

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs for the public subnets"
  value       = module.vpc.public_subnets
}
