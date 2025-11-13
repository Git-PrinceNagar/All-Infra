variable "key-vaults" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}
