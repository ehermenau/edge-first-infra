output "vpc_id" {
  description = "ID of the Hub VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs for the private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs for the public subnets"
  value       = module.vpc.public_subnets
}

output "nat_public_ips" {
  description = "Public IP of the NAT Gateway for whitelisting"
  value       = module.vpc.nat_public_ips
}
