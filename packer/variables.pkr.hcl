variable "linode_token" {
  description = "The client token to use to access your Linode account"
  sensitive   = true
  type        = string
}

variable "control_pass" {
  description = "The password for Tor's control"
  type        = string
}

variable "user" {
  description = "The username of the Linode instance"
  type        = string
}

variable "image" {
  default     = "linode/arch"
  description = "The image ID used to create the new image"
  type        = string
}

variable "image_description" {
  default = "The Linode image for the IRC Bouncer project"
  type    = string
}

variable "image_label" {
  default = "irc-bouncer-builder"
  type    = string
}

variable "region" {
  default = "us-central"
  type    = string
}

variable "instance_type" {
  default = "g6-nanode-1"
  type    = string
}

variable "swap_size" {
  default     = 512
  description = "The disk size (MiB) allocated for swap space"
  type        = string
}

variable "ssh_username" {
  default = "root"
  description = "The SSH username to use when building the image"
  type = string
}
