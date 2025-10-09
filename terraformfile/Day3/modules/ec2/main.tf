provider "aws" {
    region ="ap-southeast-1"
}

resource "aws_instance" "dell_tech" {
    instance_type = var.instance_type_value
    ami = var.ami_value
    subnet_id = var.subnet_id_value

    tags = {
      Name= "Terraform_instance"
    }
}
