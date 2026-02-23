data "aws_vpc" "hub" {
  filter {
    name   = "tag:Name"
    values = ["efi-hub-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hub.id]
  }
  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

# Fetch the public IP of the workstation running Terraform
data "http" "workstation_external_ip" {
  url = "https://checkip.amazonaws.com"
}

