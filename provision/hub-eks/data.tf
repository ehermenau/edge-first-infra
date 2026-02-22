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
