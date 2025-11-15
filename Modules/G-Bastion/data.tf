data "azurerm_subnet" "bastion_subnet" {
  for_each = var.bastion
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

