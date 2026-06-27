variable "environment" {
  type    = string
  default = "prod"
}

variable "protected_branches" {
  type    = bool
  default = true
}

variable "repository" {
  type    = string
  default = "ehermenau/edge-first-infra"
}
