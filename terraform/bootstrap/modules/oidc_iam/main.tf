# The Identity (Who is it?)
resource "aws_iam_role" "github_ci_role" {
  name = "efi-${var.environment}-IAM-role-github-deployer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "github.com:sub" : "project_path:ehermenau/edge-first-infra:*"
          }
        }
      }
    ]
  })
}

# The Permission (What can it do?)
resource "aws_iam_role_policy" "github_ci_policy" {
  name = "efi-${var.environment}-IAM-policy-github-deployer"
  role = aws_iam_role.github_ci_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:*", # Needed for Hub
          "ec2:*",     # Needed for Hub
          "eks:*",     # Needed for Hub-EKS
          "iam:*",     # Needed to create EKS node roles
          "s3:*",      # Needed for state and artifacts
          "kms:*",     # Needed for encryption
          "logs:*"     # Needed for CloudWatch logging
        ]
        Resource = "*"
        # Add a condition to restrict to your specific region
        Condition = {
          StringEquals = { "aws:RequestedRegion" : "us-east-1" }
        }
      }
    ]
  })
}

resource "github_project_variable" "aws_role_arn" {
  project = "ehermenau/edge-first-infra"
  key     = "AWS_ROLE_ARN"
  value   = aws_iam_role.github_ci_role.arn

  environment_scope = var.environment
  protected         = false
  masked            = true
}
