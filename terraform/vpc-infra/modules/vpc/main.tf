{
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "efi-${lower(var.environment)}-vpc"
  cidr = var.vpc_cidr

  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Private Subnets: /20 (4,091 IPs) - Optimized for EKS Pod density
  private_subnets = [for k in range(var.az_count) : cidrsubnet(var.vpc_cidr, 4, k)]

  # Public Subnets: /24 (251 IPs) - For Load Balancers and NAT Gateways
  public_subnets = [for k in range(var.az_count) : cidrsubnet(var.vpc_cidr, 8, k + 101)]

  enable_nat_gateway = true
  single_nat_gateway = true

  # Mandatory for EKS Load Balancer Controller
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
