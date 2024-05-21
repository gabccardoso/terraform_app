variable "regionDefault" {
  default = "us-east-1"
}

variable "labRole" {
  default = "arn:aws:iam::319971868449:role/LabRole"
}

variable "projectName" {
  default = "humburguer-eks"
}

variable "subnetA" {
  default = "subnet-0c48f973b5c4b663e"
}

variable "subnetB" {
  default = "subnet-0c5adf97854f06e2b"
}

variable "subnetC" {
  default = "subnet-0385c5962bd7eee3d"
}


variable "vpcId" {
  default = "vpc-0d566e10f00fe49ab"
}

variable "instanceType" {
  default = "t3a.medium"
}

variable "principalArn" {
  default = "arn:aws:iam::319971868449:role/voclabs"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}