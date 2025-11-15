resource "azurerm_kubernetes_cluster" "aks" {
  for_each            = var.aks_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version

  default_node_pool {
    name       = each.value.node_pool_name
    node_count = each.value.node_count
    vm_size    = each.value.vm_size
    vnet_subnet_id = data.azurerm_subnet.aks_subnet[each.key].id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = each.value.network_plugin
    network_policy    = each.value.network_policy
    service_cidr      = each.value.service_cidr
    dns_service_ip    = each.value.dns_service_ip
  }

  tags = each.value.tags
}

locals {
  flattened_additional_pools = {
    for item in flatten([
      for aks_key, aks_value in var.aks_clusters : [
        for pool_key, pool in aks_value.additional_node_pools : {
          key                   = "${aks_key}-${pool_key}"
          kubernetes_cluster_id = azurerm_kubernetes_cluster.aks[aks_key].id
          name                  = pool.name
          node_count            = pool.node_count
          vm_size               = pool.vm_size
          vnet_subnet_id        = pool.vnet_subnet_id != null ? pool.vnet_subnet_id : (pool.subnet_name != null ? data.azurerm_subnet.aks_subnet[aks_key].id : null)
          os_disk_size_gb       = pool.os_disk_size_gb
          enable_auto_scaling   = pool.enable_auto_scaling
          min_count             = pool.min_count
          max_count             = pool.max_count
        }
      ]
    ]) : item.key => {
      kubernetes_cluster_id = item.kubernetes_cluster_id
      name                  = item.name
      node_count            = item.node_count
      vm_size               = item.vm_size
      vnet_subnet_id        = item.vnet_subnet_id
      os_disk_size_gb       = item.os_disk_size_gb
      enable_auto_scaling   = item.enable_auto_scaling
      min_count             = item.min_count
      max_count             = item.max_count
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_pools" {
  for_each             = local.flattened_additional_pools
  kubernetes_cluster_id = each.value.kubernetes_cluster_id
  name                  = each.value.name
  node_count            = each.value.enable_auto_scaling ? null : each.value.node_count
  vm_size               = each.value.vm_size
  vnet_subnet_id        = each.value.vnet_subnet_id
  os_disk_size_gb       = each.value.os_disk_size_gb
  min_count             = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count             = each.value.enable_auto_scaling ? each.value.max_count : null
}

