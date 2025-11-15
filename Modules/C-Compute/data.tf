locals {
  legacy_pips = {
    for k, v in var.network_interfaces : k => {
      pip_name             = v.pip_name
      resource_group_name = v.resource_group_name
    }
    if v.pip_name != null && length(v.ip_configurations) == 0
  }

  multiple_pips = {
    for item in flatten([
      for k, v in var.network_interfaces : [
        for ip_config_key, ip_config in v.ip_configurations : {
          key                = "${k}-${ip_config.pip_name}"
          pip_name           = ip_config.pip_name
          resource_group_name = v.resource_group_name
        }
        if ip_config.pip_name != null && length(v.ip_configurations) > 0
      ]
    ]) : item.key => {
      pip_name             = item.pip_name
      resource_group_name = item.resource_group_name
    }
  }

  all_pip_references = merge(local.legacy_pips, local.multiple_pips)
}

data "azurerm_public_ip" "pip" {
  for_each            = local.all_pip_references
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