provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "devops_py_module8_s3" {

  bucket = "aws-hw-bucket-64c26dba-73f6-11ea-bc55-0242ac130003"
  acl    = "public-read-write"

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_instance" "devops_py_module8_ec2" {

  ami                         = "ami-0fc61db8544a617ed"
  instance_type               = "t2.micro"

  tags = {
    "Terraform" = "true"
    "Name"      = "module8"
  }
}
