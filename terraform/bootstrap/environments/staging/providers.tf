terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.12.1"
    }
  }

  backend "s3" {
    bucket       = "efi-staging-terraform-state"
    key          = "staging/bootstrap/terraform.tfstate"
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
      Component   = "Bootstrap"
      Environment = "Staging"
    }
  }
}
