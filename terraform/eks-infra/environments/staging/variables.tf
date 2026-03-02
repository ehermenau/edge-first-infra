variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "az_count" {
  type    = number
  default = 3
}
