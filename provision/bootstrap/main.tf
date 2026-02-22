provider "aws" {
  region = "us-east-1"
}

# Unique ID to prevent bucket name collisions
resource "random_id" "suffix" {
  byte_length = 4
}

# The Bucket 
resource "aws_s3_bucket" "state" {
  bucket = "efi-terraform-state-${random_id.suffix.hex}"

  lifecycle {
    prevent_destroy = true
  }
}

# Versioning 
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access 
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the name so we can use it in our backend config
output "state_bucket_name" {
  value = aws_s3_bucket.state.bucket
}
