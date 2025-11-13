variable "nsg" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    environment         = string
    security_rule = map(object({
      name                   = string
      priority               = number
      destination_port_range = string

    }))
  }))
}
