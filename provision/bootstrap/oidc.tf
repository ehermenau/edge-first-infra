# 1. The Identity (Who is it?)
resource "aws_iam_role" "gitlab_ci_role" {
  name = "efi-gitlab-ci-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          # Reference the existing provider's ARN
          Federated = data.aws_iam_openid_connect_provider.gitlab.arn
        }
        Condition = {
          StringLike = {
            "gitlab.com:sub" : "project_path:evanhermenau/edge-first-infrastructure:*"
          }
        }
      }
    ]
  })
}

# 2. The Permission (What can it do?)
resource "aws_iam_role_policy" "efi_infrastructure_perms" {
  name = "efi-infrastructure-policy"
  role = aws_iam_role.gitlab_ci_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*", # Needed for Hub-EKS
          "iam:*", # Needed to create EKS node roles
          "s3:*",  # Needed for state and artifacts
          "kms:*"  # Needed for encryption
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
