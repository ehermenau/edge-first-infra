variable "environment" {
  type    = string
  default = "staging"
}

variable "protected_branches" {
  type    = bool
  default = false
}

variable "repository" {
  type    = string
  default = "ehermenau/edge-first-infra"
}
