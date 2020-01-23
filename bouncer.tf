terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "bouncer_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "bouncer_vpc"
  }
}

resource "aws_subnet" "bouncer_subnet" {
  vpc_id                  = aws_vpc.bouncer_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "bouncer_subnet"
  }
}

resource "aws_security_group" "bouncer_security_group" {
  name        = "bouncer_security_group"
  vpc_id      = aws_vpc.bouncer_vpc.id
  description = "Security group for the ZNC IRC bouncer"

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

resource "aws_network_acl" "bouncer_security_acl" {
  vpc_id     = aws_vpc.bouncer_vpc.id
  subnet_ids = [aws_subnet.bouncer_subnet.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.ingress_cidr_block
    from_port  = var.irc_port
    to_port    = var.irc_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.ingress_cidr_block
    from_port  = var.ssh_port
    to_port    = var.ssh_port
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.egress_cidr_block
    from_port  = var.irc_port
    to_port    = var.irc_port
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.egress_cidr_block
    from_port  = var.ssh_port
    to_port    = var.ssh_port
  }
}

resource "aws_internet_gateway" "bouncer_internet_gateway" {
  vpc_id = aws_vpc.bouncer_vpc.id
}

resource "aws_route_table" "bouncer_route_table" {
  vpc_id = aws_vpc.bouncer_vpc.id
}

resource "aws_route" "bouncer_route" {
  route_table_id         = aws_route_table.bouncer_route_table.id
  destination_cidr_block = var.ingress_cidr_block
  gateway_id             = aws_internet_gateway.bouncer_internet_gateway.id
}

resource "aws_route_table_association" "bouncer_route_table_association" {
  subnet_id      = aws_subnet.bouncer_subnet.id
  route_table_id = aws_route_table.bouncer_route_table.id
}

resource "aws_instance" "bouncer_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.bouncer_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.bouncer_security_group.id
  ]
  tags = {
    Name = "irc bouncer"
  }
}

resource "aws_eip" "bouncer_ip" {
  vpc      = true
  instance = aws_instance.bouncer_ec2.id
}
