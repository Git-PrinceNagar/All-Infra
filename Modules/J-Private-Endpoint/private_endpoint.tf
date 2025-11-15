resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = var.private_endpoints
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet[each.key].id

  dynamic "private_service_connection" {
    for_each = each.value.private_service_connections
    content {
      name                           = private_service_connection.value.name
      private_connection_resource_id = private_service_connection.value.private_connection_resource_id
      is_manual_connection            = private_service_connection.value.is_manual_connection
      subresource_names               = private_service_connection.value.subresource_names
    }
  }

  tags = each.value.tags
}

