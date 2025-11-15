variable "private_endpoints" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    subnet_name                   = string
    virtual_network_name          = string
    private_service_connections = map(object({
      name                           = string
      private_connection_resource_id = string
      is_manual_connection            = bool
      subresource_names               = list(string)
    }))
    tags                          = optional(map(string), {})
  }))
}

