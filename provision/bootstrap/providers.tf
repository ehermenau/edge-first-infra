terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 18.9.0" # Always pin versions for stability
    }


  }

  backend "s3" {
    bucket       = "" # Passed in via var 
    key          = "bootstrap/terraform.tfstate"
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
      Environment = "Bootstrap"
      Component   = "State-Store"
    }
  }
}
