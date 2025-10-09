terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.13.0"
    }
  }
}


provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "Mercedes" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MercedesAMG"
  }
}

resource "aws_subnet" "PubSub" {
  vpc_id     = aws_vpc.Mercedes.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "PubSubnet"
  }
}

resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.Mercedes.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PubSub.id
  route_table_id = aws_route_table.PubRT.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Mercedes.id

  tags = {
    Name = "NewIGW"
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.Mercedes.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allows SSH from anywhere (not secure for prod)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowSSH"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0bfdd733094a46a0b"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.PubSub.id
  key_name = "thekeypair"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "DellTechnology"
  }
}
