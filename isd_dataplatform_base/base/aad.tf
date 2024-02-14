data "azuread_client_config" "current" {}

locals {
  eric    = "12f93e13-2602-4844-b772-f6b534984598"
  khiem   = "74a626bc-35ca-4c88-ad4d-d722d4fdb085"
  roy     = "112732af-d5f3-438b-828d-443bf974a225"
  dpsg    = "0b19fcb7-f316-4cab-9d7c-c33ffec3962b"
  ola     = "8b55bc31-6fd8-4cfd-9342-ac22f9e1c529"
  sp      = data.azuread_client_config.current.object_id
  sonia   = "1ab8a787-f465-4512-bd3d-dbeeb4cea8c4"
  ahmed   = "c96b66d8-b7aa-446f-bda6-90f28682aa5d"
  vijay   = "114e7674-b124-48df-a846-ff2523f14161"
  haritha = "dae532f1-14f4-4c4b-8a8a-4e48e156bc74"
  shawn   = "3deba69e-821d-46f0-8e48-41cfb11a836f"
  zhuren  = "fb5b5605-c69b-4a11-825f-65d02b8d0eb5"
  jeff    = "8d659fc2-2c18-4621-89c5-0316b29c386b"
  teja    = "13dddb88-257d-4138-b76f-3a34e557cd25"

  rgs_sgs = {
    "rg-302-DataPlatforms" = {
      name    = "=sg-302-DataPlatforms"
      owners  = ["${local.eric}", "${local.khiem}", "${local.ola}", "${local.sp}"]
      members = ["${local.eric}", "${local.khiem}"]
    },
    "rg-265-DataPlatforms" = {
      name    = "=sg-265-DataPlatforms"
      owners  = ["${local.eric}", "${local.roy}", "${local.ola}", "${local.sp}"]
      members = ["${local.eric}", "${local.roy}", "${local.khiem}"]
    },
    "rg-563-DataPlatforms" = {
      name    = "=sg-563-DataPlatforms"
      owners  = ["${local.eric}", "${local.ola}", "${local.sp}"]
      members = ["${local.eric}", "${local.sonia}", "${local.ahmed}", "${local.vijay}", "${local.haritha}", "${local.shawn}", "${local.zhuren}", "${local.jeff}", "${local.teja}"]
    },
    rg-306-DataPlatforms = {
      name    = "=sg-306-DataPlatforms"
      owners  = ["${local.eric}", "${local.ola}", "${local.sp}"]
      members = ["${local.eric}"]
    },
    rg-569-DataPlatforms = {
      name    = "=sg-569-DataPlatforms"
      owners  = ["${local.eric}", "${local.ola}", "${local.sp}"]
      members = ["${local.eric}"]
    },
    rg-570-DataPlatforms = {
      name    = "=sg-570-DataPlatforms"
      owners  = ["${local.eric}", "${local.roy}", "${local.ola}", "${local.sp}"]
      members = ["${local.roy}", "${local.khiem}"]
    },
    rg-263-DataPlatforms = {
      name    = "=sg-263-DataPlatforms"
      owners  = ["${local.eric}", "${local.ola}", "${local.sp}"]
      members = ["${local.eric}", "${local.roy}"]
    }
  }
}

resource "azurerm_resource_group" "rgs" {
  for_each = local.rgs_sgs
  name     = "${each.key}-${var.envr}"
  location = "uksouth"
  tags     = var.tags
  lifecycle {
    ignore_changes = [
      tags
      ]
  }
}

data "azuread_group" "sgsdata" {
  for_each     = local.rgs_sgs
  display_name = each.value.name
}

resource "azurerm_role_assignment" "rbac" {
  for_each             = local.rgs_sgs
  scope                = azurerm_resource_group.rgs[each.key].id
  role_definition_name = "cstr-DataEngineers"
  principal_id         = data.azuread_group.sgsdata[each.key].id
}

resource "azurerm_role_assignment" "rbac_grp" {
  for_each             = local.rgs_sgs
  scope                = azurerm_resource_group.rgs[each.key].id
  role_definition_name = "Reader"
  principal_id         = local.dpsg
}






# resource "azuread_group_member" "example" {
#   for_each         = { for group_name, group in var.rgs_sgs : group_name => group.members }

#   group_object_id  =   member_object_id = each.value.*.members
# }

# resource "azuread_group_member" "example" {
#   for_each = { for group_name, group in var.rgs_sgs : group_name => group.members }

#   group_object_id  = azuread_group.rgs_sgs[each.key].id
#   member_object_id = each.value
# }




# Security Groups already created in AAD dev branch/environment

# resource "azuread_group" "sgs" {
#   for_each                  = local.rgs_sgs
#   display_name              = each.value.name
#   owners                    = each.value.owners
#   members                   = each.value.members
#   security_enabled          = true
#   prevent_duplicate_names   = true
# }



# variable "rgs_sgs" {
#   description = "A map of group names and their associated properties."
#   type        = map(object({
#     name    = string
#     owners  = list(string)
#     members = list(string)
#   }))

# }
