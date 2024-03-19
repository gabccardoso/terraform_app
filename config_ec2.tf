variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}
variable "private_key" {}

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


resource "aws_instance" "Master_humburguer" {
    ami                    = "ami-0cd59ecaf368e5ccf"
    instance_type          = "t2.medium"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    key_name               = "humbuguer"
    tags = {
        Name = "Master-humburguer"
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = var.private_key 
        timeout     = "2m"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",                           
            "sudo apt-get install docker.io -y",                   
            "sudo systemctl start docker",            
            "sudo systemctl enable docker",                  
            "sudo usermod -a -G docker $(whoami)",                 
            "sudo apt-get install -y git",     
            "sudo apt-get install -y apt-transport-https ca-certificates curl gpg",
            "sudo mkdir -p -m 755 /etc/apt/keyrings",
            "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
            "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
            "sudo apt-get update",
            "sudo apt-get install -y kubelet kubeadm kubectl",
            "sudo apt-mark hold kubelet kubeadm kubectl",
            "sudo systemctl enable --now kubelet",
            "sudo kubeadm init --apiserver-advertise-address=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)",
            "sudo kubeadm token create --print-join-command > /tmp/join-command.sh",
            "curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml -O",
            "kubectl apply -f calico.yaml",
            "git clone https://github.com/gabccardoso/humbuguer_fase3.git",
            "cd humbuguer_fase3/",
            "kubectl apply -f kubernetes"
        ]
    }
}

resource "aws_instance" "Worker-node" {
    ami                    = "ami-0cd59ecaf368e5ccf"
    instance_type          = "t2.medium"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    key_name               = "humbuguer"
    tags = {
        Name = "Worker-Node-humburguer"
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = var.private_key 
        timeout     = "2m"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",                           
            "sudo apt-get install docker.io -y",                   
            "sudo systemctl start docker",            
            "sudo systemctl enable docker",                  
            "sudo usermod -a -G docker $(whoami)",                 
            "sudo apt-get install -y git",     
            "sudo apt-get install -y apt-transport-https ca-certificates curl gpg",
            "sudo apt-get update",
            "sudo mkdir -p -m 755 /etc/apt/keyrings",
            "sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
            "sudo echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
            "sudo apt-get update",
            "sudo apt-get install -y kubelet kubeadm kubectl",
            "sudo apt-mark hold kubelet kubeadm kubectl",
            "sudo systemctl enable --now kubelet",
            "sudo $(cat /tmp/join-command.sh)"
        ]
    }
}
