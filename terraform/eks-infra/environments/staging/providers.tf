terraform {
  required_version = ">= 1.10.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }

  backend "s3" {
    bucket       = "" # Passed in via var 
    key          = "staging/eks/terraform.tfstate"
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
