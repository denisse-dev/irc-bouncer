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
