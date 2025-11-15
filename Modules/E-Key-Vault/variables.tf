variable "key-vaults" {
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    sku_name                    = optional(string, "standard")
    enabled_for_disk_encryption = optional(bool, true)
    soft_delete_retention_days  = optional(number, 7)
    purge_protection_enabled    = optional(bool, false)
    tags                        = optional(map(string), {})
    access_policies = optional(map(object({
      tenant_id               = string
      object_id               = string
      key_permissions         = optional(list(string), ["Get", "List", "Create", "Update", "Delete", "Recover", "Backup", "Restore"])
      secret_permissions      = optional(list(string), ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"])
      storage_permissions     = optional(list(string), ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"])
    })), {})
    secrets = optional(map(object({
      name  = string
      value = string
    })), {})
  }))
}
