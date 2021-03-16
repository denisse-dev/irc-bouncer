source "linode" "irc_bouncer" {
  ssh_clear_authorized_keys = true

  linode_token      = var.linode_token
  ssh_username      = var.ssh_username
  image             = var.irc_bouncer_image
  region            = var.irc_bouncer_region
  instance_type     = var.irc_bouncer_instance_type
  instance_label    = var.irc_bouncer_instance_label
  instance_tags     = var.irc_bouncer_instance_tags
  swap_size         = var.irc_bouncer_swap_size
  image_label       = var.irc_bouncer_image_label
  image_description = var.irc_bouncer_image_description
}

build {
  name = "irc_bouncer"

  sources = [
    "source.linode.irc_bouncer"
  ]

  provisioner "shell" {
    inline = [
      "pacman -Syu --noconfirm",
      "pacman -S ansible --noconfirm"
    ]
  }
}
