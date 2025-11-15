variable "postgresql_servers" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    sku_name                        = string
    version                         = string
    administrator_login             = string
    administrator_login_password    = string
    ssl_enforcement_enabled         = optional(bool, true)
    tags                            = optional(map(string), {})
  }))
  default = {}
}

variable "postgresql_databases" {
  type = map(object({
    name                = string
    resource_group_name = string
    server_key          = string
    charset             = optional(string, "UTF8")
    collation           = optional(string, "English_United States.1252")
  }))
  default = {}
}

variable "sql_servers" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    version                  = string
    administrator_login      = string
    administrator_login_password = string
    minimum_tls_version       = optional(string, "1.2")
    tags                     = optional(map(string), {})
  }))
  default = {}
}

variable "sql_databases" {
  type = map(object({
    name         = string
    server_key   = string
    collation    = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    license_type = optional(string, "LicenseIncluded")
    max_size_gb  = optional(number, 2)
    sku_name     = optional(string, "Basic")
    tags         = optional(map(string), {})
  }))
  default = {}
}

