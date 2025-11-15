resource_group = {
  dev = {
    name     = "rg-dev"
    location = "Central India"
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}


virtual_networks = {
  dev_vnet = {
    name                = "vnet-10-10-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    address_space       = ["10.10.0.0/16"]
    tags = {
      environment = "Dev"
    }
    subnets = {
      dev_subnet = {
        name             = "subnet-dev"
        address_prefixes = ["10.10.1.0/24"]
      }
      bastion_subnet = {
        name             = "AzureBastionSubnet"
        address_prefixes = ["10.10.3.0/26"]
      }
    }
  }
}

network_interfaces = {
  # Frontend VM - Web server/Application frontend
  frontend = {
    # NIC Configuration
    nic_name            = "nic-frontend-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"

    # VM Configuration
    vm_name              = "vm-frontend-dev"
    size                 = "Standard_B2s"
    publisher            = "Canonical"
    offer                = "0001-com-ubuntu-server-jammy"
    sku                  = "22_04-lts"
    storage_account_type = "Premium_LRS"

    # Networking Configuration
    pip_name             = "public-ip-frontend-dev"
    subnet_name          = "subnet-dev"
    virtual_network_name = "vnet-10-10-dev"
  }

  # Backend VM - Application backend/API server
  backend = {
    # NIC Configuration
    nic_name            = "nic-backend-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"

    # VM Configuration
    vm_name              = "vm-backend-dev"
    size                 = "Standard_B2s"
    publisher            = "Canonical"
    offer                = "0001-com-ubuntu-server-jammy"
    sku                  = "22_04-lts"
    storage_account_type = "Premium_LRS"

    # Networking Configuration
    pip_name             = "public-ip-backend-dev"
    subnet_name          = "subnet-dev"
    virtual_network_name = "vnet-10-10-dev"
  }
}

public_ip = {
  # Public IP for Frontend VM
  frontend_public_ip = {
    name                = "public-ip-frontend-dev"
    resource_group_name = "rg-dev"
    location            = "Central India"
    allocation_method   = "Static"
  }
  # Public IP for Backend VM
  backend_public_ip = {
    name                = "public-ip-backend-dev"
    resource_group_name = "rg-dev"
    location            = "Central India"
    allocation_method   = "Static"
  }
}

key-vaults = {
  dev = {
    name                = "key-vault-10-10-dev"
    resource_group_name = "rg-dev"
    location            = "Central India"
  }
}

nsg = {
  dev_nsg = {
    name                = "nsg_dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    environment         = "Dev"

    security_rule = {
      ssh = {
        name                   = "allow_ssh"
        priority               = 100
        destination_port_range = "22"
      }
      HTTP = {
        name                   = "allow_http"
        priority               = 101
        destination_port_range = "80"
      }
    }
  }
}

bastion = {
  dev_bastion = {
    name                = "bastion-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    pip_name            = "bastion-pip-dev"
    allocation_method   = "Static"
    subnet_name         = "AzureBastionSubnet"
    virtual_network_name = "vnet-10-10-dev"
  }
}

storage_accounts = {
  dev_storage = {
    name                     = "stdevstorage001"
    resource_group_name      = "rg-dev"
    location                 = "Central India"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    min_tls_version          = "TLS1_2"
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

storage_containers = {
  dev_container = {
    name                  = "dev-container"
    storage_account_key   = "dev_storage"
    container_access_type = "private"
  }
}

postgresql_servers = {
  dev_postgresql = {
    name                            = "postgresql-dev-server"
    location                        = "Central India"
    resource_group_name             = "rg-dev"
    sku_name                        = "B_Gen5_2"
    version                         = "11"
    administrator_login             = "psqladmin"
    administrator_login_password    = "P@ssw0rd123!"
    ssl_enforcement_enabled         = true
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

postgresql_databases = {
  dev_postgresql_db = {
    name                = "dev-database"
    resource_group_name = "rg-dev"
    server_key          = "dev_postgresql"
    charset             = "UTF8"
    collation           = "English_United States.1252"
  }
}

sql_servers = {
  dev_sql_server = {
    name                     = "sql-dev-server"
    resource_group_name      = "rg-dev"
    location                 = "Central India"
    version                  = "12.0"
    administrator_login      = "sqladmin"
    administrator_login_password = "P@ssw0rd123!"
    minimum_tls_version       = "1.2"
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

sql_databases = {
  dev_sql_db = {
    name         = "dev-sql-database"
    server_key   = "dev_sql_server"
    collation    = "SQL_Latin1_General_CP1_CI_AS"
    license_type = "LicenseIncluded"
    max_size_gb  = 2
    sku_name     = "Basic"
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

private_endpoints = {
  dev_private_endpoint = {
    name                          = "pe-dev-storage"
    location                      = "Central India"
    resource_group_name           = "rg-dev"
    subnet_name                   = "subnet-dev"
    virtual_network_name          = "vnet-10-10-dev"
    private_service_connections = {
      pe_connection = {
        name                           = "pe-connection"
        private_connection_resource_id = "/subscriptions/xxx/resourceGroups/rg-dev/providers/Microsoft.Storage/storageAccounts/stdevstorage001"
        is_manual_connection            = false
        subresource_names               = ["blob"]
      }
    }
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

log_analytics_workspaces = {
  dev_log_analytics = {
    name                = "log-analytics-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    sku                 = "PerGB2018"
    retention_in_days   = 30
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

app_gateways = {
  dev_app_gateway = {
    name                = "app-gateway-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    subnet_name         = "subnet-dev"
    virtual_network_name = "vnet-10-10-dev"
    allocation_method   = "Static"
    sku_name            = "Standard_Small"
    sku_tier            = "Standard"
    capacity            = 2
    frontend_ports = {
      http_port = {
        name = "http-port"
        port = 80
      }
    }
    frontend_ip_configurations = {
      frontend_ip = {
        name                 = "frontend-ip"
        public_ip_address_id = null
        subnet_id            = null
      }
    }
    backend_address_pools = {
      backend_pool = {
        name = "backend-pool"
      }
    }
    backend_http_settings = {
      http_settings = {
        name                  = "http-settings"
        cookie_based_affinity = "Disabled"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 20
      }
    }
    http_listeners = {
      http_listener = {
        name                           = "http-listener"
        frontend_ip_configuration_name = "frontend-ip"
        frontend_port_name             = "http-port"
        protocol                       = "Http"
      }
    }
    request_routing_rules = {
      routing_rule = {
        name                       = "routing-rule"
        rule_type                  = "Basic"
        http_listener_name         = "http-listener"
        backend_address_pool_name  = "backend-pool"
        backend_http_settings_name = "http-settings"
      }
    }
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

load_balancers = {
  dev_load_balancer = {
    name                = "lb-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    allocation_method   = "Static"
    frontend_ip_configurations = {
      frontend_ip = {
        name                 = "frontend-ip"
        public_ip_address_id = null
        subnet_id            = null
        private_ip_address   = null
      }
    }
    probe_port          = 80
    probe_protocol      = "Http"
    rule_protocol       = "Tcp"
    frontend_port       = 80
    backend_port        = 80
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

aks_clusters = {
  dev_aks = {
    name                = "aks-dev-cluster"
    location            = "Central India"
    resource_group_name = "rg-dev"
    dns_prefix          = "aksdev"
    kubernetes_version  = "1.28"
    node_pool_name      = "default"
    node_count          = 1
    vm_size             = "Standard_D2s_v3"
    subnet_name         = "subnet-dev"
    virtual_network_name = "vnet-10-10-dev"
    network_plugin      = "azure"
    network_policy      = "azure"
    service_cidr        = "10.10.2.0/24"
    dns_service_ip      = "10.10.2.10"
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

container_registries = {
  dev_acr = {
    name                = "acrdevregistry"
    resource_group_name = "rg-dev"
    location            = "Central India"
    sku                 = "Basic"
    admin_enabled       = true
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}

application_security_groups = {
  dev_asg = {
    name                = "asg-dev"
    location            = "Central India"
    resource_group_name = "rg-dev"
    tags = {
      environment = "Dev"
      owner       = "Prince"
    }
  }
}