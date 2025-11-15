variable "network_interfaces" {
  type = map(object({
    nic_name                     = string
    location                     = string
    resource_group_name          = string
    vm_name                      = string
    size                         = string
    publisher                    = string
    offer                        = string
    sku                          = string
    version                      = optional(string, "latest")
    storage_account_type         = string
    os_disk_caching              = optional(string, "ReadWrite")
    disable_password_authentication = optional(bool, false)
    ip_configurations = optional(map(object({
      name                          = string
      private_ip_address_allocation = optional(string, "Dynamic")
      private_ip_address           = optional(string, null)
      pip_name                     = optional(string, null)
      subnet_name                  = string
    })), {})
    ip_config_name               = optional(string, "ipconfig1")
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address           = optional(string, null)
    pip_name                     = optional(string, null)
    subnet_name                  = string
    virtual_network_name         = string
    network_interface_names      = optional(list(string), [])
    key_vault_key                = optional(string, "dev")
    tags                         = optional(map(string), {})
  }))
}

variable "key-vaults" {
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}
