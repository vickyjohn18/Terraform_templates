provider "aws" {
    access_key = "here give the access key id of your aws account"
    secret_key = "here give the secret key id of your aws account"
    region = "ap-south-1"
   
  
}
resource "aws_instance" "web" {
  ami         = "ami-074dc0a6f6c764218"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = <<-EOF
  #!/bin/bash
sudo su
yum install httpd -y
service httpd start
service httpd enable
  EOF
  tags = {
    Name = "app"
  }
}
resource "aws_security_group" "sg" {
    ingress {
        description = "ssh port allow"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "all"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}
