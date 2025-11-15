variable "public_ip" {
    type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = optional(string, "Static")
    sku                 = optional(string, "Standard")
    ip_version          = optional(string, "IPv4")
    tags                = optional(map(string), {})
  }))
}