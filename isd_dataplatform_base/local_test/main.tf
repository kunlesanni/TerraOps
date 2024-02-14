# # terraform {
# #   cloud {}
# #   required_version = ">= 0.15.0"
# #   required_providers {
# #     azuread = {
# #       source = "hashicorp/azuread"
# #       version = "2.39.0"
# #     }
# #     azurerm = {
# #       source = "hashicorp/azurerm"
# #       version = "3.41.0"
# #     }

# #   }
# # }


# terraform {
#   cloud {
#     organization = "university-college-london"

#     workspaces {
#       name = "dataplatform-base"
#     }
#   }
# }

# provider "azuread" {
#   # Configuration options
# }

# # provider "azurerm" {
# #   # Configuration options
# #   features {}
# # }

# provider "azurerm" {
#   # Nonprod
#   tenant_id       = "1faf88fe-a998-4c5b-93c9-210a11d9a5c2"
#   subscription_id = "39fb3caa-1f49-4a1b-8b9e-d9394c3999be"
#   client_id       = "4ffac8cc-8384-4ee3-9641-8ac25bcc0ca6"
#   client_secret   = "YWf8Q~MRv4c.78CEiheJ53GgLNLJ6hMYjArXpcNI"
#   features {}
# }

# module "dp_base" {
#   # source = "git::https://github.com/ucl-isd/dataplatforms_iac.git//base//"
#   source = "./base"
#   rg = "rg-Dataplatform"
#   kv = "KvDp"
#   kv_admin_roleid = "/providers/Microsoft.Authorization/roleDefinitions/00482a5a-887f-4fb3-b363-3b7fe8e74483"
#   kv_secret_names = ["sqladmin","mysqladmin","postgresadmin"]
#   law             = "law-dp-01"
#   sa              = "saisddp01ad"
#   datalake        =  "dlisddp01ad"
#   email           = "+isd.database-platforms@ucl.ac.uk"
#   envr            = "dev"
#     tags = {
#     "Business Unit" = "Database Services"
#     "Budget Code"   = "573235.2002C.181592"
#     "Budget Owner"  = "cceaegu@ucl.ac.uk"
#     "Created By"    = "ccaeosa@ucl.ac.uk"
#     Environment     = "Nonprod"
#     "Contact Email" = "+isd.database-platforms@ucl.ac.uk"
#     Owner           = "cceaegu@ucl.ac.uk"
#     "Requested By"  = "cceaegu@ucl.ac.uk"
#     Terraform       = "True"
#   }
# }

terraform {
  # cloud {}
  required_version = ">= 0.15.0"
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = ">2.39.0"
    }
    # azurerm = {
    #   source = "hashicorp/azurerm"
    #   version = ">3.41.0"
    # }
  }
}

# provider "azuread" {
#   # Configuration options
# }

variable "sgs" {
  description = "Security Groups"
  # type = list(object({
  #   name    = string
  #   owners  = list(string)
  #   members = list(string)
  # }))
  default = [
    {
      name    = "test-sg-p1tf"
      owners  = ["e2c35b95-c1f3-4819-b337-119ae400ff9e", "d98bd1bd-6e76-497f-b3dd-e4cdceb142aa"]
      members = ["e2c35b95-c1f3-4819-b337-119ae400ff9e", "d98bd1bd-6e76-497f-b3dd-e4cdceb142aa"]
    }
  ]
}


# resource "example_resource" "sg" {
#   for_each = { for sg in var.sgs : sg.name => sg }

#   name    = each.value.name
#   owners  = each.value.owners
#   members = each.value.members
# }

data "azuread_client_config" "current" {}

resource "azuread_group" "sg" {
for_each = { for sg in var.sgs : sg.name => sg }
  display_name     = each.value.name
  owners           = concat(each.value.owners, [data.azuread_client_config.current.object_id])
  security_enabled = true
  members = each.value.members
  lifecycle {
    ignore_changes = [
      members,owners
    ]
  }
}
provider "azuread" {
  # features {}
  # alias           = "prod"
  # subscription_id = "812f9c72-5dc4-49af-a6d0-40b56891812e"
  tenant_id       = "1faf88fe-a998-4c5b-93c9-210a11d9a5c2"
  client_id       = "ab900b2f-c475-4322-9d47-a93123405ca9"
  client_secret   = "Vym8Q~x69mTiukx6RB11--Qge4aSYuNzNX7e_c-e"
}
