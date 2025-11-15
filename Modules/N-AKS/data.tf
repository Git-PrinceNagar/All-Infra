data "azurerm_subnet" "aks_subnet" {
  for_each = var.aks_clusters
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

