module "resource_group" {
  source = "../../Modules/A-Resource-Group"
  resource_group = var.resource_group
}

module "virtual_networks" {
  source = "../../Modules/B-Vnet"
  virtual_networks = var.virtual_networks
  depends_on = [module.resource_group]
}

module "public_ip" {
  source = "../../Modules/D-PIP"
  public_ip = var.public_ip
  depends_on = [module.resource_group]
}

module "key-vaults" {
  source = "../../Modules/E-Key-Vault"
  key-vaults = var.key-vaults
  depends_on = [module.resource_group]
}

module "network_interfaces" {
  source = "../../Modules/C-Compute"
  network_interfaces = var.network_interfaces
  key-vaults = var.key-vaults
  depends_on = [module.resource_group, module.virtual_networks, module.public_ip, module.key-vaults]
}

module "nsg" {
  source = "../../Modules/F-NSG"
  nsg = var.nsg
  depends_on = [module.resource_group, module.network_interfaces, module.public_ip, module.key-vaults]
}

