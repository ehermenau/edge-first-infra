resource "aws_route53_zone" "internal" {
  name = "efi.internal"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}
