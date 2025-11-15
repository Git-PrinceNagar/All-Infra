variable "aks_clusters" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    dns_prefix          = string
    kubernetes_version  = string
    node_pool_name      = string
    node_count          = number
    vm_size             = string
    subnet_name         = string
    virtual_network_name = string
    network_plugin      = optional(string, "azure")
    network_policy      = optional(string, "azure")
    service_cidr        = optional(string, "10.0.0.0/16")
    dns_service_ip      = optional(string, "10.0.0.10")
    additional_node_pools = optional(map(object({
      name                = string
      node_count          = number
      vm_size             = string
      subnet_name         = optional(string, null)
      vnet_subnet_id      = optional(string, null)
      os_disk_size_gb     = optional(number, 30)
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number, 1)
      max_count           = optional(number, 10)
    })), {})
    tags                = optional(map(string), {})
  }))
}

