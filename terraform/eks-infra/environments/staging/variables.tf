# adding comment to test github actions logic

variable "environment" {
  type    = string
  default = "staging"
}

variable "aws_role_arn" {
  type        = string
  description = "The IAM Role ARN used by the GitHub Runner"
}

variable "admin_user_arn" {
  type        = string
  description = "Your personal IAM ARN for emergency cluster access"
}
