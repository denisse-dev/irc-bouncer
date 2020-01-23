variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "personal"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  default = "t3.micro"
}

variable "irc_port" {
  default = 6697
}

variable "ssh_port" {
  default = 45632
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "egress_cidr_block" {
  default = "0.0.0.0/0"
}

variable "ingress_cidr_block" {
  default = "0.0.0.0/0"
}

variable "security_group_cidr_blocks" {
  default = "0.0.0.0/0"
}
