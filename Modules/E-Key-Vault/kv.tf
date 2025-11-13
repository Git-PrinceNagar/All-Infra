data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    for_each = var.key-vaults
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Update", "Delete", "Recover", "Backup", "Restore"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    storage_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]
  }
}

resource "azurerm_key_vault_secret" "username" {
  for_each     = var.key-vaults
  name         = "username"
  value        = "linux@Machine"
  key_vault_id = azurerm_key_vault.kv[each.key].id
}

resource "azurerm_key_vault_secret" "password" {
  for_each     = var.key-vaults
  name         = "password"
  value        = "986532@Machine"
  key_vault_id = azurerm_key_vault.kv[each.key].id
}