variable "virtual_networks" {
type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    tags                = optional(map(string), {})

    subnets = map(object({
      name           = string
      address_prefixes = list(string)
    }))
  }))
}