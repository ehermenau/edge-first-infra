variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "Environment must be staging or prod."
  }
}

variable "repository" {
  description = "GitHub repository name"
  type        = string
}

variable "state_bucket" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "aws_role_arn" {
  description = "The ARN of the AWS IAM role for GitHub Actions"
  type        = string
}

variable "admin_username" {
  description = "The username of the admin user for the AWS account"
  type        = string
}
