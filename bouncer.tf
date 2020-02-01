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
    from_port   = var.irc_port
    to_port     = var.irc_port
    protocol    = "tcp"
    cidr_blocks = [var.security_group_cidr_blocks]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.security_group_cidr_blocks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.security_group_cidr_blocks]
  }
}

resource "aws_instance" "irc_bouncer" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
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
