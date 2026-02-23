# Fetch AZs dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

# Pull Edge VPC metadata for Peering and Routing
data "terraform_remote_state" "edge" {
  backend = "s3"

  config = {
    bucket = "your-hardcoded-bucket-name"
    key    = "edge/terraform.tfstate"
    region = "us-east-1"
  }
}
