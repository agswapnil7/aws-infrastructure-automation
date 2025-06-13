provider "aws" {
  region = "us-east-1"
}

# Random ID for unique bucket naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 Bucket
resource "aws_s3_bucket" "terraform_jenkins_bucket" {
  bucket = "terraform-jenkins-s3-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Terraform-Jenkins-S3-Bucket"
    Environment = "Development"
    CreatedBy   = "Jenkins-Pipeline"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_jenkins_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.terraform_jenkins_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket = aws_s3_bucket.terraform_jenkins_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Sample S3 Object
resource "aws_s3_object" "sample_file" {
  bucket = aws_s3_bucket.terraform_jenkins_bucket.id
  key    = "sample/jenkins-terraform-test.txt"
  content = "This file was created by Jenkins pipeline using Terraform on ${timestamp()}"
  
  tags = {
    CreatedBy = "Jenkins-Terraform-Pipeline"
  }
}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.terraform_jenkins_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.terraform_jenkins_bucket.arn
}

output "bucket_region" {
  value = aws_s3_bucket.terraform_jenkins_bucket.region
}