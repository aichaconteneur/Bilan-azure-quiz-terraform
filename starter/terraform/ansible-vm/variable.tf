variable "owner" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type    = string
  default = "subnet-ansible"
}

variable "subnet_address_prefix" {
  type = string
}

variable "nsg_name" {
  type    = string
  default = "nsg-ansible"
}

variable "public_ip_name" {
  type    = string
  default = "public-ip-ansible"
}

variable "my_public_ip" {
  description = "IP publique autorisée pour SSH"
  type        = string
}

variable "vm_name" {
  type    = string
  default = "ansible-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "tls_private_key_algorithm" {
  type    = string
  default = "RSA"
}
