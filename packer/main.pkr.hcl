packer {
  required_plugins {
    linode = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}

source "linode" "irc_bouncer" {
  image             = var.image
  image_description = var.image_description
  image_label       = var.image_label
  instance_label    = var.image_label
  instance_type     = var.instance_type
  linode_token      = var.linode_token
  region            = var.region
  ssh_username      = var.ssh_username
  swap_size         = var.swap_size
}

build {
  name = "irc_bouncer"
  sources = [
    "source.linode.irc_bouncer"
  ]

  provisioner "shell" {
    inline = [
      "pacman -Sy reflector --noconfirm",
      "reflector --country us --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose",
      "sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf",
      "pacman -Su --noconfirm",
      "pacman -S ansible --noconfirm"
    ]
  }

  provisioner "ansible-local" {
    playbook_dir   = "ansible"
    playbook_files = [
      "ansible/user.yml",
      "ansible/packages.yml",
      "ansible/hardening.yml",
      "ansible/znc.yml",
      "ansible/tor.yml"
    ]
    extra_arguments = [
      "--extra-vars",
      "\"control_pass=${var.control_pass}\"",
      "-vvv"
    ]
    galaxy_command = "ansible-galaxy collection install --requirements-file"
    galaxy_file = "ansible/requirements.yml"
  }
}
