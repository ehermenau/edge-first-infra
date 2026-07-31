terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  # This layer is intentionally single-environment: an ECR repository, an
  # ACM certificate, and a GitHub OIDC role aren't per-cluster concepts like
  # vpc-infra/eks-infra are — there is exactly one public scanner tool, so
  # there's exactly one of each. It's also intentionally excluded from
  # auto_destroy.yml: none of these resources cost anything at rest, and
  # nightly-cycling them would rotate the ACM certificate ARN under the
  # GitOps Ingress manifest that references it statically.
  backend "s3" {
    bucket       = "" # Passed in via var
    key          = "global/scanner-infra/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "Edge-First-Infrastructure"
      ManagedBy   = "Terraform"
      Component   = "Scanner"
      Environment = "Prod"
    }
  }
}

provider "cloudflare" {
  # Uses CLOUDFLARE_API_TOKEN environment variable
}
