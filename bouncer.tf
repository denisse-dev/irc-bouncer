terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_instance" "irc_bouncer" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
}

resource "aws_eip" "bouncer_ip" {
  vpc      = true
  instance = aws_instance.irc_bouncer.id
}
