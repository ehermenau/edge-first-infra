# environments/staging/providers.tf

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "" # Passed in via var 
    key          = "hub/terraform.tfstate"
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
      Component   = "Control-Plane"
      Environment = "Staging"
    }
  }
}
