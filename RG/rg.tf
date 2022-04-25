resource "azurerm_resource_group" "tfdeploy2" {
    name = "DevOpsTFRG"
    location = "uk south"
}

provider "azurerm" {
    features {
    }
}
