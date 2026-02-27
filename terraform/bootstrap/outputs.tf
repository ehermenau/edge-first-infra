# Output the name so we can use it in our backend config
output "state_bucket_name" {
  value = aws_s3_bucket.state.bucket
}

# Output IAM role ARN to be used for gitlab CICD variable 
output "gitlab_ci_role_arn" {
  description = "The ARN of the IAM Role for GitLab CI/CD OIDC authentication"
  value       = aws_iam_role.gitlab_ci_role.arn
}
