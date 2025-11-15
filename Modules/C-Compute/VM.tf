resource "azurerm_network_interface" "nic" {
  for_each            = var.network_interfaces
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "ip_configuration" {
    for_each = length(each.value.ip_configurations) > 0 ? each.value.ip_configurations : {
      default = {
        name                          = each.value.ip_config_name
        private_ip_address_allocation = each.value.private_ip_address_allocation
        private_ip_address            = each.value.private_ip_address
        pip_name                      = each.value.pip_name
        subnet_name                   = each.value.subnet_name
      }
    }
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = data.azurerm_subnet.subnets[each.key].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.pip_name != null ? (
        length(each.value.ip_configurations) > 0 ? data.azurerm_public_ip.pip["${each.key}-${ip_configuration.value.pip_name}"].id : data.azurerm_public_ip.pip[each.key].id
      ) : null
    }
  }

  tags = each.value.tags
}


resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.network_interfaces
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.username[each.value.key_vault_key].value
  admin_password                  = data.azurerm_key_vault_secret.password[each.value.key_vault_key].value
  disable_password_authentication = each.value.disable_password_authentication
  network_interface_ids = length(each.value.network_interface_names) > 0 ? [
    for nic_name in each.value.network_interface_names : azurerm_network_interface.nic[nic_name].id
  ] : [
    azurerm_network_interface.nic[each.key].id,
  ]
  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.storage_account_type
  }
  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

  tags = each.value.tags
}
