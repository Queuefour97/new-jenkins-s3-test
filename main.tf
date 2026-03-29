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

resource "aws_s3_bucket_website_configuration" "aws_s3_website" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/forS3bucket03262026.png"
  source       = "./forS3bucket03262026.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./forS3bucket03262026.png")
}
resource "aws_s3_object" "object2" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/ec2jenkinsbucket.png"
  source       = "./ec2jenkinsbucket.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./ec2jenkinsbucket.png")
}
resource "aws_s3_object" "object3" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/jenkinspipeline1.png"
  source       = "./jenkinspipeline1.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./jenkinspipeline1.png")
}
resource "aws_s3_object" "object4" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/s3bucketinjenkins.png"
  source       = "./s3bucketinjenkins.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./s3bucketinjenkins.png")
}
resource "aws_s3_object" "object5" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/webhook_proof.png"
  source       = "./webhook_proof.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./webhook_proof.png")
}
resource "aws_s3_object" "object6" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/webhook_proof2.png"
  source       = "./webhook_proof2.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./webhook_proof2.png")
}

resource "aws_s3_object" "object7" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/armageddon_repo_screenshot_non_forked.png"
  source       = "./armageddon_repo_screenshot_non_forked.png"
  content_type = "image/png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./armageddon_repo_screenshot_non_forked.png")

}

resource "aws_s3_object" "object8" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/armageddon_repo_link.md"
  source       = "./armageddon_repo_link.md"
  content_type = "text/markdown; charset=UTF-8"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./armageddon_repo_link.md")

}

resource "aws_s3_object" "object9" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "images/lab3b_runbook.docx"
  source       = "${path.module}/lab3b_runbook.docx"
  content_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${path.module}/lab3b_runbook.docx")
}
resource "aws_s3_bucket_public_access_block" "frontend_public_access" {
  bucket = aws_s3_bucket.frontend.bucket



  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.frontend.bucket

  depends_on = [aws_s3_bucket_public_access_block.frontend_public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}