variable "load_balancers" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = optional(string, "Static")
    frontend_ip_configurations = map(object({
      name                 = string
      public_ip_address_id = optional(string)
      subnet_id            = optional(string)
      private_ip_address   = optional(string)
    }))
    probe_port          = optional(number, 80)
    probe_protocol      = optional(string, "Http")
    rule_protocol        = optional(string, "Tcp")
    frontend_port        = optional(number, 80)
    backend_port         = optional(number, 80)
    backend_address_pools = optional(map(object({
      name = string
    })), {})
    probes = optional(map(object({
      name                = string
      port                = number
      protocol            = string
      interval_in_seconds = optional(number, 15)
      number_of_probes    = optional(number, 2)
    })), {})
    rules = optional(map(object({
      name                           = string
      protocol                       = string
      frontend_port                  = number
      backend_port                   = number
      frontend_ip_configuration_name = string
      backend_address_pool_name      = string
      probe_name                     = string
    })), {})
    tags                 = optional(map(string), {})
  }))
}

