output "vpc_id" {
  description = "ID of the VPC (Passed to Remote State)"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "IDs of the private subnets (Passed to Remote State)"
  value       = module.vpc.private_subnets
}
