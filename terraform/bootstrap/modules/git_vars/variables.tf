variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "Environment must be staging or prod."
  }
}

variable "protected_branches" {
  description = "Whether to enforce protected branches for the environment. Set to true for production, false for staging."
  type        = bool
  validation {
    condition     = contains([true, false], var.protected_branches)
    error_message = "Protected branches must be a boolean value."
  }
}

variable "repository" {
  description = "GitHub repository name"
  type        = string
}
