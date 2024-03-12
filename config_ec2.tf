provider "aws" {
    access_key = "ASIAZQ3DTIAMIHHAIUQT"
    secret_key = "2lR26RW1bqli1JZMVovy2yz2SJRgnlrhgU0Wecxo"
    token = "FwoGZXIvYXdzEEEaDDCWDSWRqYKasCdV7yLGAb4ZRqXeQpWOtUFV9FG6ITF92ZZN7ZlLKHU1HdKnSKr5m4zUnESnL2891MfFD4jJfqDOIVg3LPfzy4CPoBtYW1qPkJrAs600z7FPPauXCNN0xWoci5KyWrTgdbuvodBPXz8ZTLiM6jChjLPzSi2GZwyEouIZql31TUnv0aXf0yWw7wvemBXCqt0ocNHh0hkUxDqNlODDcIi7Lur3HJvyh9/WKK3WyfnDlhlbsAitX5C71sYRfTzFftzdpEttJZ9Nrv6MpTeBLSiCtr6vBjIt0sKmK6/JOS7kixT2ZOWPGC9lj1v9dZFsk14Aj4fxZGcK743mTOK0T44AxW7J"
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
