resource "azurerm_application_security_group" "asg" {
  for_each            = var.application_security_groups
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  tags = each.value.tags
}

