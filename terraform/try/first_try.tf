provider "aws" {
  profile = "default"
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform_try" {
  bucket = "tf-bucket-64c26dba-73f6-11ea-bc55-0242ac130003"
  acl = "private"
} 

