variable "linode_token" {
  type        = string
  sensitive   = true
  description = "The client token to use to access your account."
}

variable "ssh_username" {
  type        = string
  default     = "root"
  description = "The SSH username used by the Packer communicator."
}

variable "irc_bouncer_image" {
  type        = string
  default     = "linode/arch"
  description = "The image ID used to create the new image."
}

variable "irc_bouncer_region" {
  type        = string
  default     = "us-central"
  description = "The ID of the region to store the Linode image in."
}

variable "irc_bouncer_instance_type" {
  type        = string
  default     = "g6-nanode-1"
  description = "The Linode instance type that defines the pricing, CPU, disk, and RAM specs of the instance."
}

variable "irc_bouncer_instance_label" {
  type        = string
  default     = "irc_bouncer_builder"
  description = "The name assigned to the Linode Instance that builds the image."
}

variable "irc_bouncer_instance_tags" {
  type        = list(string)
  default     = ["irc_bouncer", "personal"]
  description = "The tags to apply to the image when it is created."
}

variable "irc_bouncer_swap_size" {
  type        = string
  default     = 512
  description = "The disk size (MiB) allocated for swap space."
}

variable "irc_bouncer_image_label" {
  type        = string
  default     = "irc_bouncer"
  description = "The name of the resulting image that will appear in your Linode account."
}

variable "irc_bouncer_image_description" {
  type        = string
  default     = "The Linode image for the IRC Bouncer project"
  description = "The description of the resulting image that will appear in your account."
}
