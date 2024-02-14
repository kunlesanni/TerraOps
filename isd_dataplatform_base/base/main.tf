# Retrieve the current Azure client configuration
data "azurerm_client_config" "current" {}

locals {
  rg              = "${var.rg}-${var.envr}"
  kv              = "${var.kv}${var.envr}"
  kv_admin_roleid = var.kv_admin_roleid
  kv_secret_names = var.kv_secret_names
  law             = "${var.law}-${var.envr}"
  sa              = "${var.sa}${var.envr}"
  datalake        = "${var.datalake}${var.envr}"
  email           = var.email
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg
  location = "uksouth"
  tags     = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  # Ignore changes to a particular tag
  #   lifecycle {
  #     ignore_changes = [tags.CreatedOn]
  # }

}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

resource "azurerm_key_vault" "kv" {
  depends_on = [
    azurerm_resource_group.rg
  ]
  name                          = local.kv
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  sku_name                      = "standard"
  public_network_access_enabled = true
  enable_rbac_authorization     = true
  tags                          = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_role_assignment" "kv_rbac" {
  for_each           = toset(["${local.eric}", "${local.roy}", "${local.ola}", "${local.sp}"])
  scope              = azurerm_key_vault.kv.id
  role_definition_id = local.kv_admin_roleid
  principal_id       = each.value
  lifecycle {
    ignore_changes = [
      role_definition_id
    ]
  }
}

# generate random password
resource "random_password" "dbadmin_pswd" {
  length           = 16
  special          = true
  override_special = "_%@#$&*(){}<>:?"
}

resource "azurerm_key_vault_secret" "sqlsrvpswd" {
  depends_on = [
    azurerm_role_assignment.kv_rbac
  ]
  for_each     = toset(local.kv_secret_names)
  name         = each.value
  value        = random_password.dbadmin_pswd.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = local.law
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = 30
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_account" "sa" {
  name                          = local.sa
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  account_tier                  = "Standard"
  is_hns_enabled                = false
  public_network_access_enabled = false
  account_replication_type      = "GRS"
  tags                          = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_account" "datalake" {
  name                          = local.datalake
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  account_tier                  = "Standard"
  is_hns_enabled                = true
  public_network_access_enabled = false
  account_replication_type      = "GRS"
  tags                          = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_monitor_action_group" "agrp" {
  name                = "DataPlatformActionGroup"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "dpag"

  email_receiver {
    name                    = "SendToDataPlatform"
    email_address           = local.email
    use_common_alert_schema = true
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_user_assigned_identity" "uami" {
  location            = var.location
  name                = "uami-dp-${var.envr}"
  resource_group_name = azurerm_resource_group.rg.name
}