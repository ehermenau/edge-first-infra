variable "repository" {
  type    = string
  default = "edge-first-infra"
}

variable "admin_username" {
  description = "The username of the admin user for the AWS account"
  type        = string
  default     = "Terraform-Admin"
}
