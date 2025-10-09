provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_instance" "Mclaren" {
    ami=var.ami_value
    instance_type=var.instance_type_value
    subnet_id = var.subnet_id_value
  
}