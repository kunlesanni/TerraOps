terraform {
  cloud {}
  required_version = ">= 0.15.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.39.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  # Configuration options
  features {}
}

# resource "null_resource" "get_date" {
#   provisioner "local" {
#     command = "date +'%d/%m/%Y'"
#   }

#   output {
#     value = trim(stdout())
#   }
# }

module "dp_base" {
  # source = "git::https://github.com/ucl-isd/dataplatforms_iac.git//base//"
  source          = "./base"
  rg              = "rg-Dataplatforms"
  kv              = "KvisdDp01"
  kv_admin_roleid = "/providers/Microsoft.Authorization/roleDefinitions/00482a5a-887f-4fb3-b363-3b7fe8e74483"
  kv_secret_names = ["sqladmin", "mysqladmin", "pgsqladmin"]
  law             = "law-dp-01"
  sa              = "stgisddp01"
  datalake        = "adlsisddp01"
  email           = "+isd.database-platforms@ucl.ac.uk"
  envr            = "prod"
  tags = {
    "Business Unit" = "Database Services"
    "Budget Code"   = "573235.2002C.181592"
    "Budget Owner"  = "cceaegu@ucl.ac.uk"
    "Created By"    = "ccaeosa@ucl.ac.uk"
    Environment     = "Prod"
    "Contact Email" = "+isd.database-platforms@ucl.ac.uk"
    Owner           = "cceaegu@ucl.ac.uk"
    "Requested By"  = "cceaegu@ucl.ac.uk"
    CreatedOn       = formatdate("DD/MM/YYYY", timestamp())
    Terraform       = "True"
  }
}
