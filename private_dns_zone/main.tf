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


