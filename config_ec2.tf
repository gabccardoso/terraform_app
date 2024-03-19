provider "aws" {
  region = "us-east-1"
  access_key = ${{ secrets.AWS_ACCESS_KEY_ID }}
  secret_key = ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  token = ${{ secrets.AWS_SESSION_TOKEN }}
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
