terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "a564e508-b2a0-480e-9729-97d54d09f44e"
  client_id       = "b6fc9423-3b96-418c-8a66-30e673cd6878"
  client_secret   = "ydj8Q~5f2l2jK6TSYyNji4mkudB~jpfsFWlp2akA"
  tenant_id       = "251fe175-13cb-400c-affc-7105f5c904e2"
}