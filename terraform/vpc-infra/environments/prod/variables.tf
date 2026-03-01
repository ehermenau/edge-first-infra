variable "vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "az_count" {
  type    = number
  default = 3
}
