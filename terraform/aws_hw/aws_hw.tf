provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_security_group" "aws_hw_sg" {
  name        = "Cert_Book"
  description = "Allow ssh from my laptop"
   vpc_id     = aws_vpc.aws_hw_vpc.id

  ingress {
    description = "ssh allow"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_ssh"
    "Terraform" = "true"
  }
}

resource "aws_s3_bucket" "aws_hw_s3" {

  bucket = "aws-hw-bucket-64c26dba-73f6-11ea-bc55-0242ac130003"
  acl    = "public-read-write"

  tags = {
    "Terraform" = "true"
  }
} 

resource "aws_instance" "aws_hw_ec2" {

  ami                         = "ami-0fc61db8544a617ed"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.aws_hw_subnet1.id
  key_name                    = aws_key_pair.aws_hw_ssh.key_name

  tags = {
    "Terraform" = "true"
    "Name"      = "Exercise 1"
  }
}


resource "tls_private_key" "priv-deployer-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_hw_ssh" {
  key_name   = var.key_name
  public_key = tls_private_key.priv-deployer-key.public_key_openssh
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.aws_hw_sg.id
  network_interface_id = aws_instance.aws_hw_ec2.primary_network_interface_id
}

resource "aws_ebs_volume" "aws_hw_ebs" {
  availability_zone = "us-east-1a"
  size              = 8

  tags = {
    "Terraform" = "true"
    "Name"      = "Exercise 3"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.aws_hw_ebs.id
  instance_id = aws_instance.aws_hw_ec2.id
}

resource "aws_vpc" "aws_hw_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name        = "My First VPC"
    "Terraform" = "true"
  }
}

resource "aws_subnet" "aws_hw_subnet1" {
  vpc_id                  = aws_vpc.aws_hw_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "My First Public Subnet"
    "Terraform" = "true"
  }
}

resource "aws_subnet" "aws_hw_subnet2" {
  vpc_id            = aws_vpc.aws_hw_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "My First Private Subnet"
    "Terraform" = "true"
  }
}

resource "aws_internet_gateway" "aws_hw_gw" {
  vpc_id = aws_vpc.aws_hw_vpc.id

  tags = {
    Name        = "My First IGW"
    "Terraform" = "true"
  }
}

resource "aws_route_table" "awa_hw_rt" {
  vpc_id = aws_vpc.aws_hw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_hw_gw.id
  }

  tags = {
    Name        = "no idea"
    "Terraform" = "true"
  }
}