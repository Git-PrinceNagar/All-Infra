data "azurerm_subnet" "private_endpoint_subnet" {
  for_each = var.private_endpoints
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

