provider "azurerm" {
  features {}
}

variable "vmall" {
  default = [
    {
      name      = "vm1"
      rg        = "rg1"
      sb        = "sb1"
      sb_prefix = ["10.0.1.0/24"]
    },
    {
      name      = "vm2"
      rg        = "rg2"
      sb        = "sb2"
      sb_prefix = ["10.0.2.0/24"]
    }
  ]
}
output "vmall" {
  value = var.vmall
}

resource "azurerm_resource_group" "rg" {
  for_each = { for vmall in var.vmall : vmall.rg => vmall }
  # for_each = toset(var.vmall)
  name     = each.value.rg
  location = var.location
}

resource "azurerm_resource_group" "SharedRG" {
  name     = var.shared_rg
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.SharedRG.name
}

resource "azurerm_subnet" "subnet" {
  for_each             = { for vmall in var.vmall : vmall.sb => vmall }
  name                 = each.value.sb
  resource_group_name  = each.value.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.sb_prefix
}

resource "azurerm_network_interface" "nic" {
  for_each            = { for vmall in var.vmall : "${vmall.name}-nic" => vmall }
  name                = "${each.value.name}-nic"
  location            = var.location
  resource_group_name = each.value.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[each.value.sb].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each            = { for vmall in var.vmall : vmall.name => vmall }
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg[each.value.rg].name
  location            = var.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  admin_password      = "Default@12345"
  network_interface_ids = [
    azurerm_network_interface.nic["${each.value.name}-nic"].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}