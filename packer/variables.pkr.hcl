variable "linode_token" {
  type        = string
  sensitive   = true
  description = "The client token to use to access your Linode account"
}

variable "user" {
  type        = string
  description = "The username of the Linode instance"
}

variable "image" {
  type        = string
  default     = "linode/arch"
  description = "The image ID used to create the new image"
}

variable "region" {
  type        = string
  default     = "us-central"
  description = "The ID of the region to store the Linode image in"
}

variable "instance_type" {
  type        = string
  default     = "g6-nanode-1"
  description = "The Linode instance type that defines the pricing, CPU, disk, and RAM specs of the instance"
}

variable "swap_size" {
  type        = string
  default     = 512
  description = "The disk size (MiB) allocated for swap space"
}

variable "ssh_username" {
  type = string
  default = "root"
  description = "The SSH username to use when building the image"
}
