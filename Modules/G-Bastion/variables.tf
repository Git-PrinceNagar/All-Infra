variable "bastion" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    pip_name            = string
    allocation_method   = optional(string, "Static")
    pip_sku             = optional(string, "Standard")
    ip_config_name      = optional(string, "configuration")
    subnet_name         = string
    virtual_network_name = string
    tags                = optional(map(string), {})
  }))
}

