terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "backend-bucket-830"          # Name of the S3 bucket
    key     = "jenkins-test-032326.tfstate" # The name of the state file in the bucket
    region  = "us-east-1"                   # Use a variable for the region
    encrypt = true                          # Enable server-side encryption (optional but recommended)
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true


  tags = {
    Name = "Jenkins Bucket"
  }
}
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "images/forS3bucket03262026.png"
  source = "./forS3bucket03262026.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./forS3bucket03262026.png")
}