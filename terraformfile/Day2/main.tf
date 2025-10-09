provider "aws" {
  region = "ap-southeast-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-0bfdd733094a46a0b"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-06c0e40a8133fc4a4"
}