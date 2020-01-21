terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_security_group" "bouncer_security_group" {
  name        = "bouncer_security_group"
  description = "Allow the ZNC IRC Bouncer to communicate"

  ingress {
    from_port   = 6697
    to_port     = 6697
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 45632
    to_port     = 45632
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "bouncer_key" {
  key_name   = "bouncer_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "irc_bouncer" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bouncer_key.key_name
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.bouncer_security_group.name
  ]
  tags = {
    Name = "irc bouncer"
  }
}

resource "aws_eip" "bouncer_ip" {
  vpc      = true
  instance = aws_instance.irc_bouncer.id
}
