resource "azurerm_resource_group" "tfdeploy3" {
    name = "DevOpsTFRGCD"
    location = "uk south"
}

provider "azurerm" {
    features {
    }
}
