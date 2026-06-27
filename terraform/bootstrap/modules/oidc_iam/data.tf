# Look up the existing GitHub provider by URL
data "aws_iam_openid_connect_provider" "github" {
  url = "https://github.com"
}
