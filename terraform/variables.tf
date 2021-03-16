################################################################################
# Project wide variables
################################################################################
variable "linode_token" {
  type        = string
  sensitive   = true
  description = "The client token to use to access your account."
}

variable "region" {
  type        = string
  default     = "us-central"
  description = "The location where the Linode is deployed."
}

variable "tags" {
  type        = list(string)
  default     = ["irc_bouncer", "archlinuxmx"]
  description = "The tags to apply to the resources when they are created."
}


################################################################################
# linode_instance irc_bouncer variables
################################################################################
variable "linode_instance_irc_bouncer_label" {
  type        = string
  default     = "irc_bouncer"
  description = "The name assigned to the Linode Instance."
}

variable "linode_instance_irc_bouncer_group" {
  type        = string
  default     = "irc_bouncer"
  description = "The display group of the Linode instance."
}


variable "linode_instance_irc_bouncer_image" {
  type        = string
  description = "The OS image used to deploy the instance."
}

variable "linode_instance_irc_bouncer_type" {
  type        = string
  default     = "g6-nanode-1"
  description = "The Linode instance type that defines the pricing, CPU, disk, and RAM specs of the instance."
}

variable "linode_instance_irc_bouncer_root_pass" {
  type        = string
  sensitive   = true
  description = "The password for the root user."
}

variable "linode_instance_irc_bouncer_swap_size" {
  type        = string
  default     = 512
  description = "The disk size (MiB) allocated for swap space."
}

variable "linode_instance_irc_bouncer_private_ip" {
  type        = bool
  default     = false
  description = "The private IP address for private networking."
}
