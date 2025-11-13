data "azurerm_public_ip" "pip" {
  for_each = var.network_interfaces
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}
data "azurerm_subnet" "subnets" {
  for_each = var.network_interfaces
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_key_vault" "kvault" {
  for_each = var.key-vaults
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "username" {
  for_each = var.key-vaults
  name         = "username"
  key_vault_id = data.azurerm_key_vault.kvault[each.key].id
}

data "azurerm_key_vault_secret" "password" {
  for_each = var.key-vaults
  name         = "password"
  key_vault_id = data.azurerm_key_vault.kvault[each.key].id
}