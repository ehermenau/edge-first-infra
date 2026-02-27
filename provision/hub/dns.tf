resource "aws_route53_zone" "internal" {
  name = "efi.internal"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  # This tag overrides the 'Blue' tag from providers.tf
  tags = {
    Name  = "efi-internal-phz"
    Space = "Interconnect"
  }
}
