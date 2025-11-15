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

module "bastion" {
  source = "../../Modules/G-Bastion"
  bastion = var.bastion
  depends_on = [module.resource_group, module.virtual_networks]
}

module "storage_accounts" {
  source = "../../Modules/H-Storage-Account"
  storage_accounts = var.storage_accounts
  storage_containers = var.storage_containers
  depends_on = [module.resource_group]
}

module "databases" {
  source = "../../Modules/I-Database"
  postgresql_servers = var.postgresql_servers
  postgresql_databases = var.postgresql_databases
  sql_servers = var.sql_servers
  sql_databases = var.sql_databases
  depends_on = [module.resource_group]
}

module "private_endpoints" {
  source = "../../Modules/J-Private-Endpoint"
  private_endpoints = var.private_endpoints
  depends_on = [module.resource_group, module.virtual_networks]
}

module "log_analytics" {
  source = "../../Modules/K-Log-Analytics"
  log_analytics_workspaces = var.log_analytics_workspaces
  depends_on = [module.resource_group]
}

module "app_gateways" {
  source = "../../Modules/L-App-Gateway"
  app_gateways = var.app_gateways
  depends_on = [module.resource_group, module.virtual_networks]
}

module "load_balancers" {
  source = "../../Modules/M-Load-Balancer"
  load_balancers = var.load_balancers
  depends_on = [module.resource_group]
}

module "aks_clusters" {
  source = "../../Modules/N-AKS"
  aks_clusters = var.aks_clusters
  depends_on = [module.resource_group, module.virtual_networks]
}

module "container_registries" {
  source = "../../Modules/O-ACR"
  container_registries = var.container_registries
  depends_on = [module.resource_group]
}

module "application_security_groups" {
  source = "../../Modules/P-ASG"
  application_security_groups = var.application_security_groups
  depends_on = [module.resource_group]
}
