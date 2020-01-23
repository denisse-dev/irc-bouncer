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

variable "security_group_cidr_blocks" {
  default = "0.0.0.0/0"
}
