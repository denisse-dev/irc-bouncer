terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  profile = var.profile
  region = var.region
}

resource "aws_key_pair" "bouncer_key" {
  key_name = "bouncer_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "irc_bouncer" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.bouncer_key.key_name
  associate_public_ip_address = true

  provisioner "remote-exec" {
    script = "bouncer.sh"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host     = self.public_ip
    }
  }

  depends_on = [aws_key_pair.bouncer_key]
}

resource "aws_eip" "bouncer_ip" {
  vpc = true
  instance = aws_instance.irc_bouncer.id
}
