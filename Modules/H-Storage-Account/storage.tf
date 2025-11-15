resource "azurerm_storage_account" "storage" {
  for_each                 = var.storage_accounts
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = each.value.account_kind
  min_tls_version          = each.value.min_tls_version

  tags = each.value.tags
}

resource "azurerm_storage_container" "containers" {
  for_each              = var.storage_containers
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.storage[each.value.storage_account_key].id
  container_access_type = each.value.container_access_type
}

