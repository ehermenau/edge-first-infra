variable "environment" {
  type    = string
  default = "prod"
}

variable "protected_branches" {
  type    = bool
  default = true
}

variable "custom_branch_policies" {
  type    = bool
  default = false
}

variable "repository" {
  type    = string
  default = "edge-first-infra"
}

variable "github_owner" {
  type    = string
  default = "ehermenau"
}
