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

resource "aws_instance" "example" {
  ami           = "ami-0bfdd733094a46a0b"
  instance_type = "t3.micro"
  subnet_id = "subnet-06c0e40a8133fc4a4"
  key_name = "thekeypair"

  tags = {
    Name = "DellTechnology"
  }
}