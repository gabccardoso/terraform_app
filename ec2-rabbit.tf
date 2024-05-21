

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
    from_port   = 15672
    to_port     = 15672
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


resource "aws_instance" "rabbit" {
    ami                    = "ami-0cd59ecaf368e5ccf"
    instance_type          = "t2.medium"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    key_name               = "fiap-fase3"
    tags = {
        Name = "rabbitmq-server"
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = file("./fiap-fase3.pem")
        timeout     = "2m"
    }
    provisioner "remote-exec" {
        inline = [
          "sudo apt-get update -y",
          "sudo apt-get install wget apt-transport-https -y",
          "wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -",
          "echo \"deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang-22.x\" | sudo tee /etc/apt/sources.list.d/rabbitmq.list",
          "sudo apt-get install rabbitmq-server -y --fix-missing"
        ]
    }
}