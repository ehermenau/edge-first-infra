terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "efi-terraform-state-30cd8fad" # Hardcoded string required here
    key          = "edge/terraform.tfstate"
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
      Environment = "Hub"
      Space       = "Blue"
    }
  }
}
