#PROVIDER BLOCK
provider "aws" {
  region = "us-east-1"
}

#S3 BUCKET
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname

}

#OWNERSHIP CONTROLS
resource "aws_s3_bucket_ownership_controls" "rights" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#PUBLIC ACCESS BLOCK
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#ACL
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.rights,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}
## Keep teh name different in the " " than the one in key and source or else it will gv error##
#S3 OBJECTS - index.html
resource "aws_s3_object" "ind" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

#S3 OBJECTS - error.html
resource "aws_s3_object" "err" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

#S3 OBJECTS - style.css
resource "aws_s3_object" "styl" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "style.css"
  source       = "style.css"
  acl          = "public-read"
  content_type = "text/css"
}

#S3 OBJECT - profile-image
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "ayush.jpg"
  source = "ayush.jpg"
  acl    = "public-read"
}

#S3 OBJECT - bg-image
resource "aws_s3_object" "bg" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "webbg.jpg"
  source = "webbg.jpg"
  acl    = "public-read"
}

# WEBSITE CONFIGURATION
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example]

}


