variable "app_gateways" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_name         = string
    virtual_network_name = string
    allocation_method   = optional(string, "Static")
    sku_name            = optional(string, "Standard_Small")
    sku_tier            = optional(string, "Standard")
    capacity            = optional(number, 2)
    frontend_ports = map(object({
      name = string
      port = number
    }))
    frontend_ip_configurations = map(object({
      name                 = string
      public_ip_address_id = optional(string)
      subnet_id            = optional(string)
    }))
    backend_address_pools = map(object({
      name = string
    }))
    backend_http_settings = map(object({
      name                  = string
      cookie_based_affinity = string
      port                  = number
      protocol              = string
      request_timeout       = number
    }))
    http_listeners = map(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
    }))
    request_routing_rules = map(object({
      name                       = string
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))
    tags = optional(map(string), {})
  }))
}

