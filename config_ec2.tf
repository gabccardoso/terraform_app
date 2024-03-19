variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token = var.aws_session_token
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow inbound SSH and HTTP traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   # Permitir todo o tráfego de entrada
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "Master" {
    ami                    = "ami-0cd59ecaf368e5ccf"
    instance_type          = "t2.medium"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    key_name               = "humbuguer"
    tags = {
        Name = "Master"
    }
}

resource "aws_instance" "Worker-node" {
    ami                    = "ami-0cd59ecaf368e5ccf"
    instance_type          = "t2.medium"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    key_name               = "humbuguer"
    tags = {
        Name = "Worker-Node"
    }
}
