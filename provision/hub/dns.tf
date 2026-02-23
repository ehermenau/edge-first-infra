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

resource "aws_route53_zone_association" "edge" {
  zone_id = aws_route53_zone.internal.zone_id
  vpc_id  = data.terraform_remote_state.edge.outputs.vpc_id

}

resource "aws_route53_record" "test" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "discovery.efi.internal"
  type    = "A"
  ttl     = "300"
  records = ["10.1.255.254"] # Dummy IP for testing
}
