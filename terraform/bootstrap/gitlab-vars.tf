## requires valid gitlab PAT scoped with correct perms 

# 1. Automatically push the ARN back to GitLab
resource "gitlab_project_variable" "aws_role_arn" {
  project   = "evanhermenau/edge-first-infrastructure"
  key       = "AWS_ROLE_ARN"
  value     = aws_iam_role.gitlab_ci_role.arn
  protected = true
  masked    = true
}

# 2. Push the S3 Bucket name for the other tiers
resource "gitlab_project_variable" "tf_state_bucket" {
  project   = "evanhermenau/edge-first-infrastructure"
  key       = "TF_STATE_BUCKET"
  value     = aws_s3_bucket.state.bucket
  protected = true
}
