variable "linode_token" {
  type        = string
  sensitive   = true
  description = "The client token to use to access Linode"
}

variable "image" {
  type        = string
  description = "The OS image used to deploy the instance"
}

variable "label" {
  type    = string
  default = "irc-bouncer"
}

variable "region" {
  type        = string
  default     = "us-central"
  description = "The location where the Linode is deployed"
}

variable "swap_size" {
  type        = string
  default     = 512
  description = "The disk size (MiB) allocated for swap space"
}

variable "type" {
  type        = string
  default     = "g6-nanode-1"
  description = "The Linode instance type"
}

variable "watchdog_enabled" {
  type        = bool
  default     = true
  description = "The watchdog reboots an instance if it powers off unexpectedly"
}
