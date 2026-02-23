# Fetch AZs dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

# Pull Edge VPC metadata for Peering and Routing
data "terraform_remote_state" "edge" {
  backend = "s3"

  config = {
    bucket = "efi-terraform-state-30cd8fad"
    key    = "edge/terraform.tfstate"
    region = "us-east-1"
  }
}
