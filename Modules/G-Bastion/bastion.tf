resource "azurerm_public_ip" "bastion_pip" {
  for_each            = var.bastion
  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.pip_sku
  tags                = each.value.tags
}

resource "azurerm_bastion_host" "bastion" {
  for_each            = var.bastion
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = each.value.ip_config_name
    subnet_id            = data.azurerm_subnet.bastion_subnet[each.key].id
    public_ip_address_id = azurerm_public_ip.bastion_pip[each.key].id
  }

  tags = each.value.tags
}

