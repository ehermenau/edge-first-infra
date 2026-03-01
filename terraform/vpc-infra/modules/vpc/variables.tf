# vpc-infra/modules/vpc/variables.tf

variable "az_count" {
  description = "Number of Availability Zones to utilize"
  type        = number
  default     = 3
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
