output "bucket_name" {
  value       = aws_s3_bucket.state.bucket
  description = "The name of the S3 bucket for Terraform state"
}
