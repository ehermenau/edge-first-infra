# --- Container registry ---

resource "aws_ecr_repository" "scanner" {
  name                 = "fetchlabs-scanner"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "scanner" {
  repository = aws_ecr_repository.scanner.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = { type = "expire" }
      }
    ]
  })
}

# --- ACM certificate for the public ALB, DNS-validated via Cloudflare ---

resource "aws_acm_certificate" "scanner" {
  domain_name       = "${var.subdomain}.${var.root_domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.scanner.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = 60
  proxied = false # ACM validation needs a direct DNS answer, not Cloudflare's proxy
}

resource "aws_acm_certificate_validation" "scanner" {
  certificate_arn         = aws_acm_certificate.scanner.arn
  validation_record_fqdns = [for dvo in aws_acm_certificate.scanner.domain_validation_options : dvo.resource_record_name]

  depends_on = [cloudflare_dns_record.acm_validation]
}

# --- OIDC role for fetchlabs-scanner's own CI ---
#
# Deliberately separate from edge-first-infra's own deployer role
# (terraform/bootstrap/modules/oidc_iam) rather than reusing it: that role
# is scoped to route53/ec2/eks/iam/s3/kms/logs on Resource:"*" because it
# needs to stand up whole clusters. This role only ever needs to push one
# image to one ECR repository, so it's built least-privilege from the
# start instead of inheriting that blast radius.
resource "aws_iam_role" "scanner_ci" {
  name = "efi-scanner-IAM-role-github-deployer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        # GitHub now includes immutable numeric owner/repo IDs in the sub
        # claim (repo:OWNER@OWNER_ID/REPO@REPO_ID:environment:ENV), not just
        # the mutable names - closes a trust hijack via repo rename/transfer.
        # Confirmed empirically for this exact repo by decoding a live OIDC
        # token in CI (owner id via `gh api users/<owner>`, repo id via
        # `gh api repos/<owner>/<repo>`, or just print the token's own sub
        # claim as done here if this ever needs re-deriving).
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}@${var.github_owner_id}/${var.repository}@${var.repository_id}:environment:production"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "scanner_ci_ecr_push" {
  name = "efi-scanner-IAM-policy-ecr-push"
  role = aws_iam_role.scanner_ci.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # ecr:GetAuthorizationToken has no resource-level permissions in the
        # ECR API - AWS requires Resource "*" for this action specifically.
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchGetImage",
        ]
        Resource = aws_ecr_repository.scanner.arn
      }
    ]
  })
}
