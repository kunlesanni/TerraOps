resource "azurerm_subnet" "subnet" {
  for_each = local.vnet_all
  name                 = each.value.sn
  resource_group_name  = azurerm_resource_group.SharedRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.sn_prefix
}

data "azurerm_subnet" "sndata"{
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name  = azurerm_resource_group.SharedRG.name
    name = "subnet4"
}

output "snid" {
    # value = ["${azurerm_subnet.subnet.*.id}"]
    value = [ for subnet in azurerm_subnet.subnet : subnet.id ]
}

# merges but not in order with provided subnet prefix list
output "merge_idip" {
    value = zipmap(var.sn_prefixes, [for subnet in azurerm_subnet.subnet : subnet.id])
}