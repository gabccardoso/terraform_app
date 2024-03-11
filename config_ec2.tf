provider "aws" {
    access_key = "ASIAZQ3DTIAMC2ZJR775"
    secret_key = "FTD3/KnEfPUMb30BjzvRph8eOnn/RkfdZIDRteij"
    token = "FwoGZXIvYXdzEDcaDAaRb8KUjacNJ5f32yLGAbOlp5MdIF+tspysz5tanTZ0mIMS8s9/KBArhRE0KFhuUUFku3o4tjrXkFql4eGuL1rVpshQBFJ/l/ogforCfai7BjfpYWcOtL3I6QBiQlPDzi17365DQDGZKj9eD6MV11yltoXg2XA0/3lKa+7dpTWapWN/Ajf4HVNd34LO2lPmYTdV1vnphCH/TFPrc7DtZs5ggXVVOCFqQHk+/YUKTs9MBVrRKJDAI6J5JlHFEa4rAgvHXUAeYO2ZKJR7FYtIHx2ifOq/NSikl7yvBjItvI869KRF2xuOghpZ7HBKSWEMhpP/jSPxjpRXPNnppfGQz1wNwKIgMIFkWvPe"
    region = "us-east-1"
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
