module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "efi-${var.environment}-eks-cluster"
  kubernetes_version = "1.35"

  vpc_id     = data.aws_vpc.hub.id
  subnet_ids = data.aws_subnets.private.ids

  # Enable public access until we can lock it down via ZT 
  endpoint_public_access = true

  # EKS Auto Mode: AWS manages the 'general-purpose' compute nodes
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
}
