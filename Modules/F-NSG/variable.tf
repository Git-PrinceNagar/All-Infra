variable "nsg" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    environment         = optional(string, "")
    security_rule = map(object({
      name                       = string
      priority                   = number
      destination_port_range    = string
      direction                  = optional(string, "Inbound")
      access                     = optional(string, "Allow")
      protocol                   = optional(string, "Tcp")
      source_port_range          = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    }))
    tags = optional(map(string), {})
  }))
}
