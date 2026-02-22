variable "az_count" {
  description = "Number of Availability Zones to utilize"
  type        = number
  default     = 3
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Hub"
}
