variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "Environment must be staging or prod."
  }
}

variable "aws_role_arn" {
  description = "ARN of the IAM Role used by github CICD"
  type        = string
}

variable "admin_user_arn" {
  description = "ARN of the admin user that will access the EKS cluster"
  type        = string
}
