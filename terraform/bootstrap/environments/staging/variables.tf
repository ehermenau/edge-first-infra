variable "environment" {
  type    = string
  default = "staging"
}

variable "protected_branches" {
  type    = bool
  default = false
}

variable "custom_branch_policies" {
  type    = bool
  default = true
}

variable "repository" {
  type    = string
  default = "edge-first-infra"
}

variable "github_owner" {
  type    = string
  default = "ehermenau"
}
