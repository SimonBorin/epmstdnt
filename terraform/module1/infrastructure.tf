provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc-module1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Terraform = "true"
    resource = var.devops_school_tag
  }
}

resource "aws_subnet" "subnet-module1" {
  cidr_block        = cidrsubnet(aws_vpc.vpc-module1.cidr_block, 3, 1)
  vpc_id            = aws_vpc.vpc-module1.id
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "allow_ssh" {
name   = "allos-ssh"
vpc_id = aws_vpc.vpc-module1.id
ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "allow_docker" {
  name        = "allow-tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc-module1.id
  ingress {
    description = "docker deamon"
    from_port   = 2376
    to_port     = 2376
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
    Name = "allow_tls"
  }
}

resource "aws_instance" "ec2-module1" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_docker.id
  ]
  tags = {
      Terraform = "true"
      resource = var.devops_school_tag
    }
  subnet_id = aws_subnet.subnet-module1.id
}

resource "aws_eip" "ip-vpc-module1" {
  instance = aws_instance.ec2-module1.id
  vpc      = true
}

resource "aws_internet_gateway" "vpc-module1-gw" {
  vpc_id = aws_vpc.vpc-module1.id

  tags = {
      Terraform = "true"
      resource = var.devops_school_tag
    }
}

resource "aws_route_table" "route-table-vpc-module1" {
  vpc_id = aws_vpc.vpc-module1.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.vpc-module1-gw.id
    }

  tags = {
      Terraform = "true"
      resource = var.devops_school_tag
    }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet-module1.id
  route_table_id = aws_route_table.route-table-vpc-module1.id
}

