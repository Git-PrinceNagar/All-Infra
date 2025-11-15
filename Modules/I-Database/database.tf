resource "azurerm_postgresql_server" "postgresql" {
  for_each                         = var.postgresql_servers
  name                             = each.value.name
  location                         = each.value.location
  resource_group_name              = each.value.resource_group_name
  sku_name                         = each.value.sku_name
  version                          = each.value.version
  administrator_login              = each.value.administrator_login
  administrator_login_password     = each.value.administrator_login_password
  ssl_enforcement_enabled          = each.value.ssl_enforcement_enabled

  tags = each.value.tags
}

resource "azurerm_postgresql_database" "postgresql_db" {
  for_each            = var.postgresql_databases
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql[each.value.server_key].name
  charset             = each.value.charset
  collation           = each.value.collation
}

resource "azurerm_mssql_server" "sql_server" {
  for_each                         = var.sql_servers
  name                             = each.value.name
  resource_group_name              = each.value.resource_group_name
  location                         = each.value.location
  version                          = each.value.version
  administrator_login              = each.value.administrator_login
  administrator_login_password     = each.value.administrator_login_password
  minimum_tls_version              = each.value.minimum_tls_version

  tags = each.value.tags
}

resource "azurerm_mssql_database" "sql_database" {
  for_each            = var.sql_databases
  name                = each.value.name
  server_id           = azurerm_mssql_server.sql_server[each.value.server_key].id
  collation           = each.value.collation
  license_type        = each.value.license_type
  max_size_gb         = each.value.max_size_gb
  sku_name            = each.value.sku_name

  tags = each.value.tags
}

