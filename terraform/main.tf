terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
  required_version = ">= 0.14"
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "irc_bouncer" {
  tags             = var.tags
  region           = var.region
  group            = var.linode_instance_irc_bouncer_group
  image            = var.linode_instance_irc_bouncer_image
  label            = var.linode_instance_irc_bouncer_label
  private_ip       = var.linode_instance_irc_bouncer_private_ip
  root_pass        = var.linode_instance_irc_bouncer_root_pass
  swap_size        = var.linode_instance_irc_bouncer_swap_size
  type             = var.linode_instance_irc_bouncer_type
  watchdog_enabled = true

  alerts {
    cpu = 85
  }
}
