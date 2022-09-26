terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}
# for idx, name in var.vm_names: 
            # name => 


# snid = "/subscriptions/9fb17648-7619-4a0e-9f17-577a6a3500aa/resourceGroups/SharedRG1/providers/Microsoft.Network/virtualNetworks/HubVNET1/subnets/subnet4"

locals {
      vnet_all = {for idx, name in var.rg_names : 
      name =>            {
              rg      = var.rg_names[idx]
              sn  = var.subnets[idx]
              sn_prefix = [var.sn_prefixes[idx]]
            #   sn_id = toset([ for subnet in data.azurerm_subnet.sndata : subnet.id ])
      }
      }
}


provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "SharedRG" {
    name = "SharedRG1"
    location = var.location
}

resource "azurerm_resource_group" "rg" {
    for_each = local.vnet_all
    name = each.value.rg
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "HubVNET1"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.SharedRG.name
}

resource "azurerm_subnet" "subnet" {
  for_each = local.vnet_all
  name                 = each.value.sn
  resource_group_name  = azurerm_resource_group.SharedRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.sn_prefix
}

# data "azurerm_subnet" "sndata" {
#   for_each = local.vnet_all
#   name                 = each.value.sn
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
# }

resource "azurerm_network_interface" "nic" {
  for_each            = local.vnet_all
  name                = each.value.rg
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[each.value.rg].name

  ip_configuration {
    name                          = "internal"
    # subnet_id                     = [for subnet in azurerm_subnet.subnet : subnet[each.value.sn].id]
    private_ip_address_allocation = "Dynamic"
  }
}

# data "azurerm_subnet" "sndata"{
#     virtual_network_name = azurerm_virtual_network.vnet.name
#     resource_group_name  = azurerm_resource_group.SharedRG.name
#     name = "subnet4"
# }

# output "snid" {
#     # value = ["${azurerm_subnet.subnet.*.id}"]
#     value = [ for subnet in azurerm_subnet.subnet : subnet.id ]
# }

# output "merge_idip" {
#     value = zipmap(var.sn_prefixes, [for subnet in azurerm_subnet.subnet : subnet.id])
# }

# output "snidout_ordered" {
#     value = "${element(azurerm_subnet.subnet.*.id, each.value.sn)}"
# }

output "snid_ordered2" {
    value =  [for subnet in azurerm_subnet.subnet : subnet.id]
}