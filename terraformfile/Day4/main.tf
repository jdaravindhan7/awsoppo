provider "aws" {
  region = "ap-southeast-1"
}
variable "Cidr" {
    default = "10.0.0.0/16"
}

resource "aws_key_pair" "kkey" {
    key_name= "thekeypair2"
    public_key= file("C:/Users/aravi/Downloads/thekeypair.pub")
}

resource "aws_vpc" "VPCrevolution" {
    cidr_block = var.Cidr

    tags = {
        name = "terraformvpc"
    }
}

resource "aws_subnet" "publicsub" {
    vpc_id =  aws_vpc.VPCrevolution.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.VPCrevolution.id
}

resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.VPCrevolution.id

    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "Route" {
    route_table_id = aws_route_table.publicRT.id
    subnet_id = aws_subnet.publicsub.id
}

resource "aws_security_group" "sg" {
    name = "VPC_security"
    vpc_id = aws_vpc.VPCrevolution.id

    ingress {
        description = "from the http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        description = "from the ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["49.37.211.173/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
      name = "vpc-securitygp"
    }
}

resource "aws_instance" "server" {
    ami = "ami-0bfdd733094a46a0b"
    instance_type = "t2.micro"
    key_name = aws_key_pair.kkey.key_name
    vpc_security_group_ids= [aws_security_group.sg.id]
    subnet_id = aws_subnet.publicsub.id

    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:/Users/aravi/Downloads/thekeypair.pem")
        host = self.public_ip
    }

    provisioner "file" {
        source = "app.py"
        destination = "/home/ec2-user/app.py"
      
    }

   provisioner "remote-exec" {
    inline = [
        "echo 'Hello from the remote instance'",
        "sudo yum update -y",                 # Update packages (Amazon Linux uses yum/dnf)
        "sudo yum install -y python3-pip",    # Install pip for Python 3
        "cd /home/ec2-user",
        "pip3 install flask --user",          # Install Flask (best practice is --user for ec2-user)
        "nohup python3 app.py > app.log 2>&1 &"  # Run Flask app in background
    ]
}
}




