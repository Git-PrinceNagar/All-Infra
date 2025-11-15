data "azurerm_subnet" "app_gateway_subnet" {
  for_each = var.app_gateways
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

