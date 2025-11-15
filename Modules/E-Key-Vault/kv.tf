data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    for_each = var.key-vaults
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_disk_encryption = each.value.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  purge_protection_enabled    = each.value.purge_protection_enabled

  sku_name = each.value.sku_name

  tags = each.value.tags

  dynamic "access_policy" {
    for_each = length(each.value.access_policies) > 0 ? each.value.access_policies : {
      default = {
        tenant_id           = data.azurerm_client_config.current.tenant_id
        object_id           = data.azurerm_client_config.current.object_id
        key_permissions     = ["Get", "List", "Create", "Update", "Delete", "Recover", "Backup", "Restore"]
        secret_permissions  = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
        storage_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
      }
    }
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id

      key_permissions = access_policy.value.key_permissions

      secret_permissions = access_policy.value.secret_permissions

      storage_permissions = access_policy.value.storage_permissions
    }
  }
}

locals {
  flattened_secrets = {
    for item in flatten([
      for kv_key, kv_value in var.key-vaults : [
        for secret_key, secret in kv_value.secrets : {
          key         = "${kv_key}-${secret_key}"
          key_vault_id = azurerm_key_vault.kv[kv_key].id
          name         = secret.name
          value        = secret.value
        }
      ]
    ]) : item.key => {
      key_vault_id = item.key_vault_id
      name         = item.name
      value        = item.value
    }
  }
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = local.flattened_secrets
  name         = each.value.name
  value        = each.value.value
  key_vault_id = each.value.key_vault_id
}