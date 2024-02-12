locals {
    vnet_ids = {
      "vnet-hubc-uks"           = "/subscriptions/effec6ac-0c2f-40d8-ac3e-7ea8f2116d46/resourceGroups/rg-vlz-connectivity-uks/providers/Microsoft.Network/virtualNetworks/vnet-hubc-uks"
      "vnet-hubi-ad-uks"        = "/subscriptions/0bda8ad9-83ea-4731-8328-842b719dfe8d/resourceGroups/rg-vlz-identity-uks/providers/Microsoft.Network/virtualNetworks/vnet-hubi-ad-uks"
      "vnet-hubi-addev-uks"     = "/subscriptions/0bda8ad9-83ea-4731-8328-842b719dfe8d/resourceGroups/rg-dc-hubi-dev/providers/Microsoft.Network/virtualNetworks/vnet-hubi-addev-uks"
      "vnet-prod-uks"           = "/subscriptions/812f9c72-5dc4-49af-a6d0-40b56891812e/resourceGroups/rg-vlz-connectivity-uks/providers/Microsoft.Network/virtualNetworks/vnet-prod-uks"
      "vnet-dev-uks"            = "/subscriptions/39fb3caa-1f49-4a1b-8b9e-d9394c3999be/resourceGroups/rg-vlz-connectivity-uks/providers/Microsoft.Network/virtualNetworks/vnet-dev-uks"
      }
}


module "blob_pdns_zone" {
  source = "./pdns_zone"
  for_each = local.vnet_ids
  rg = "rg-vlz-connectivity-uks"
  pdns_zone = "guladnszone.myprivatezoen.com"
  vnet    = each.value
  vnet_id = each.key
  tags = {
    Environment = "Production"
    Owner = "ISD Cloud Platform"
    "Requested By" = "BAU"
    CreatedOn = formatdate("DD/MM/YYYY", timestamp())
    Terraform = "True"
  }
}

resource "azurerm_private_dns_zone" "pdns_zone" {
  name                = var.pdns_zone
  resource_group_name = var.rg
  tags = var.tags
  }
  
resource "azurerm_private_dns_zone_virtual_network_link" "pdns_zone" {
  name                  = "vnetlink-${var.vnet}"
  resource_group_name   = var.rg
  private_dns_zone_name = azurerm_private_dns_zone.pdns_zone.name
  virtual_network_id    = var.vnet_id
}

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
