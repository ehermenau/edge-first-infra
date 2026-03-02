module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "efi-hub-cluster"
  kubernetes_version = "1.35"

  vpc_id     = data.aws_vpc.hub.id
  subnet_ids = data.aws_subnets.private.ids

  # Security: The Hybrid access model
  endpoint_public_access  = true
  endpoint_private_access = true
  # endpoint_public_access_cidrs = ["${chomp(data.http.workstation_external_ip.response_body)}/32"]

  # Identity: Add current user as admin
  # enable_cluster_creator_admin_permissions = true

  # EKS Auto Mode: AWS manages the 'general-purpose' compute nodes
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
}
