locals {
  rhelgalleryImageVersionName   = ""
  rhelgalleryImageDefinitionName = ""
  keyVaultName = ""
  keyVaultResourceGroupName = ""
}

data "azurerm_key_vault" "key_vault" {
  name                = local.keyVaultName
  resource_group_name = local.keyVaultResourceGroupName
}

data "azurerm_shared_image_version" "rhelasgi" {
  name                = local.rhelgalleryImageVersionName
  image_name          = local.rhelgalleryImageDefinitionName
  gallery_name        = var.galleryName
  resource_group_name = var.ACG_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.vnet_resource_group_name
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_interface" "rhelnic" {
  name                = "${var.vm_name}02-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create linux virtual machine
resource "azurerm_linux_virtual_machine" "rhelvm" {
  depends_on            = ["azurerm_network_interface.rhelnic, tls_private_key.example_ssh"]
  name                  = "${var.vm_name}02"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.rhelnic.id]
  size                  = "Standard_DS1_v2"
  source_image_id       = data.azurerm_shared_image_version.rhelasgi.id
  os_disk {
    name                 = "${var.vm_name}02-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  computer_name                   = "${var.vm_name}02"
  admin_username                  = "adminuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }
}

resource "azurerm_key_vault_secret" "vm_password" {
  depends_on = ["azurerm_virtual_machine.rhelvm"]
  name         = "${var.vm_name}02"
  value        = "${tls_private_key.ssh_key.private_key_pem}"
  key_vault_id = azurerm_key_vault.key_vault.id
}
