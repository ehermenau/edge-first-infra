terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    github = {
      source  = "githubhq/github"
      version = "~> 18.9.0"
    }
  }
}
