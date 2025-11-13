variable "network_interfaces" {
  type = map(object({
    nic_name            = string
    location            = string
    resource_group_name = string
    # VM properties
    vm_name             = string
    size                = string
    publisher           = string
    offer               = string
    sku                 = string
    storage_account_type = string

    # References for networking and PIP
    pip_name             = string
    subnet_name          = string
    virtual_network_name = string

  }))
}

variable "key-vaults" {
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}
