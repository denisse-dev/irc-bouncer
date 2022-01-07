terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.25.1"
    }
  }
  required_version = ">= 0.14"
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "irc_bouncer" {
  image            = var.image
  region           = var.region
  swap_size        = var.swap_size
  type             = var.type
  watchdog_enabled = var.watchdog_enabled

  alerts {
    cpu = 90
  }
}
