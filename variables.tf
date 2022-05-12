variable "resource_group_name" {
  default       = "test-rg01"
  description   = "Resource group name where the new resources to be created."
}

variable "ACG_resource_group_name" {
  default       = "test-asg-rg01"
  description   = "Resource group name where Image is present."
}

variable "galleryName" {
  default       = "test-asg-rg01"
  description   = "Azure Compute gallery name."
}

variable "vnet_resource_group_name" {
  default       = "test-vnet-rg01"
  description   = "Virtual network resource group name."
}

variable "virtual_network_name" {
  default       = "test-rg01"
  description   = "Name of the Virtual Network."
}

variable "subnet_name" {
  default       = "test-rg01"
  description   = "Name of the subnet."
}

variable "vm_name" {
  default       = "testVM"
  description   = "Virtual machine name prefix."
}

variable "location" {
  default       = "westeurope"
  description   = "Location of the VM"
}

variable "domainjoin_username" {
  default       = "testuser"
  description   = "username for the account to be used for domain joining."
}

variable "domainjoin_password" {
  default       = ""
  description   = "Password for the domain join account."
}



