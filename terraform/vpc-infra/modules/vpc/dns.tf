resource "aws_route53_zone" "internal" {
  name = "${var.environment}.${var.namespace}"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name = "${var.environment}-internal-zone"
  }
}
