resource "azurerm_resource_group" "RG" {
  for_each = var.resource_group
  name     = each.value.name
  location = each.value.location
  managed_by = each.value.managed_by
  tags     = each.value.tags
}