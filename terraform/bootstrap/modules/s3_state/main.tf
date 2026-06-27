# The Bucket 
resource "aws_s3_bucket" "state" {
  bucket = "efi-${var.environment}-terraform-state"

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

resource "github_actions_variable" "tf_state_bucket" {
  repository = "ehermenau/edge-first-infra"
  secret_name     = "TF_STATE_BUCKET"
  value   = aws_s3_bucket.state.bucket

  environment_scope = var.environment
  protected         = false
  masked            = true
}
