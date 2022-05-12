locals {
  wingalleryImageVersionName    = ""
  wingalleryImageDefinitionName = ""
  keyVaultName = ""
  keyVaultResourceGroupName = ""
  adminPasswordSecretName = ""
}

data "azurerm_key_vault" "key_vault" {
  name                = local.keyVaultName
  resource_group_name = local.keyVaultResourceGroupName
}

data "azurerm_key_vault_secret" "vm_password_secret" {
  name         = local.adminPasswordSecretName
  key_vault_id = data.azurerm_key_vault.existing.id
}

data "azurerm_shared_image_version" "windowsasgi" {
  name                = local.wingalleryImageVersionName
  image_name          = local.wingalleryImageDefinitionName
  gallery_name        = var.galleryName
  resource_group_name = var.ACG_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.vnet_resource_group_name
}

resource "azurerm_network_interface" "windowsnic" {
  name                = "${var.vm_name}01-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windowsvm" {
  depends_on          = ["azurerm_network_interface.windowsnic"]
  name                = "${var.vm_name}01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "${data.azurerm_key_vault_secret.vm_password_secret.value}"
  source_image_id     = data.azurerm_shared_image_version.windowsasgi.id
  network_interface_ids = [
    azurerm_network_interface.windowsnic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_virtual_machine_extension" "domjoin" {
    depends_on = ["azurerm_virtual_machine.windowsvm"]
    name = "domjoin"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    virtual_machine_name = "${azurerm_virtual_machine.windowsvm.name}"
    publisher = "Microsoft.Compute"
    type = "JsonADDomainExtension"
    type_handler_version = "1.3"
    # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain
    settings = <<SETTINGS
    {
    "Name": "pixelrobots.co.uk",
    "OUPath": "OU=Servers,DC=pixelrobots,DC=co,DC=uk",
    "User": "${var.domainjoin_username}",
    "Restart": "true",
    "Options": "3"
    }
    SETTINGS
    protected_settings = <<PROTECTED_SETTINGS
    {
    "Password": "${var.domainjoin_password}"
    }
    PROTECTED_SETTINGS
}