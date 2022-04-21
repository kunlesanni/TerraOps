resource "azurerm_resource_group" "tfdeploy1" {
    name = "TFRG1"
    location = "uk south"
}

resource "azurerm_storage_account" "tfdeploy1stg" {
    name = "tfstgacctf9m1"
    resource_group_name = azurerm_resource_group.tfdeploy1.name
    location = azurerm_resource_group.tfdeploy1.location
    account_tier = "Standard"
    account_replication_type = "LRS"
    
}
provider "azurerm" {
    features {
    }
}
