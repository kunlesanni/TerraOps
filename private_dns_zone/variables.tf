variable "rg" {
    description = "The name of the resource group where the private dns zone will be created"
}

variable "pdns_zone" {
    description = "The name of the private dns zone"
}

variable "tags" {
    description = "The tags to be assigned to the private dns zone"
}

variable "vnet" {
    description = "The name of the virtual network"
}

variable "vnet_id" {
    description = "The name of the virtual network"
}
