# Look up the existing GitLab provider by URL
data "aws_iam_openid_connect_provider" "gitlab" {
  url = "https://gitlab.com"
}
