# Output the name so we can use it in our backend config
output "state_bucket_name" {
  value = aws_s3_bucket.state.bucket
}
