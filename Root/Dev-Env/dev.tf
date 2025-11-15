# ============================================================================
# MODULE: Resource Group
# ============================================================================
# Purpose: Creates Azure Resource Groups to organize and manage Azure resources
# Dependencies: None (this is the foundation module)
# Best Practices:
#   - Use consistent naming conventions (e.g., rg-{environment}-{purpose})
#   - Apply tags for cost management and resource organization
#   - Consider using managed_by for resources managed by other services
# ============================================================================
module "resource_group" {
  source = "../../Modules/A-Resource-Group"
  resource_group = var.resource_group
}

# ============================================================================
# MODULE: Virtual Networks
# ============================================================================
# Purpose: Creates Azure Virtual Networks (VNets) and subnets for network isolation
# Dependencies: Resource Group
# Best Practices:
#   - Plan CIDR blocks carefully to avoid conflicts
#   - Use /26 or larger for subnets (Azure requires minimum /29)
#   - AzureBastionSubnet requires /26 or larger
#   - Consider hub-spoke architecture for enterprise deployments
# Security: Subnets provide network segmentation and security boundaries
# ============================================================================
module "virtual_networks" {
  source = "../../Modules/B-Vnet"
  virtual_networks = var.virtual_networks
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Public IP Addresses
# ============================================================================
# Purpose: Creates public IP addresses for internet-facing resources
# Dependencies: Resource Group
# Best Practices:
#   - Use Static allocation for production workloads
#   - Use Standard SKU for better security and features
#   - Consider using Azure Front Door or Application Gateway for web apps
# Security: Public IPs expose resources to internet - ensure proper NSG rules
# ============================================================================
module "public_ip" {
  source = "../../Modules/D-PIP"
  public_ip = var.public_ip
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Azure Key Vault
# ============================================================================
# Purpose: Secure storage for secrets, keys, and certificates
# Dependencies: Resource Group
# Best Practices:
#   - Enable soft delete and purge protection for production
#   - Use RBAC for access control (preferred over access policies)
#   - Rotate secrets regularly
#   - Enable diagnostic settings for audit logging
# Security: 
#   - Never commit secrets to code - always use Key Vault
#   - Use managed identities where possible
#   - Implement least privilege access policies
# ============================================================================
module "key-vaults" {
  source = "../../Modules/E-Key-Vault"
  key-vaults = var.key-vaults
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Compute (Virtual Machines)
# ============================================================================
# Purpose: Creates Linux Virtual Machines with Network Interfaces
# Dependencies: Resource Group, VNet, Public IP, Key Vault
# Features:
#   - Supports multiple IP configurations per NIC (dynamic blocks)
#   - Supports multiple NICs per VM
#   - Retrieves credentials from Key Vault for security
# Best Practices:
#   - Use managed disks (Premium SSD for production)
#   - Enable Azure Backup for critical VMs
#   - Use Availability Sets or Availability Zones for HA
#   - Consider Azure Virtual Machine Scale Sets for scalability
# Security:
#   - Credentials stored in Key Vault (never hardcoded)
#   - Use SSH keys instead of passwords when possible
#   - Apply NSG rules to restrict network access
# ============================================================================
module "network_interfaces" {
  source = "../../Modules/C-Compute"
  network_interfaces = var.network_interfaces
  key-vaults = var.key-vaults
  depends_on = [module.resource_group, module.virtual_networks, module.public_ip, module.key-vaults]
}

# ============================================================================
# MODULE: Network Security Groups
# ============================================================================
# Purpose: Implements network-level security rules (firewall) for subnets/NICs
# Dependencies: Resource Group, Network Interfaces
# Features:
#   - Dynamic security rules (supports multiple rules)
#   - Configurable direction, protocol, ports, and address prefixes
# Best Practices:
#   - Follow principle of least privilege
#   - Use Application Security Groups (ASG) for better management
#   - Deny all by default, allow only required traffic
#   - Use service tags and ASGs instead of IP addresses when possible
# Security:
#   - Rules are evaluated by priority (lower number = higher priority)
#   - Default rules: Allow VNet inbound, Allow Azure Load Balancer inbound
#   - Deny all inbound/outbound by default
# ============================================================================
module "nsg" {
  source = "../../Modules/F-NSG"
  nsg = var.nsg
  depends_on = [module.resource_group, module.network_interfaces, module.public_ip, module.key-vaults]
}

# ============================================================================
# MODULE: Azure Bastion Host
# ============================================================================
# Purpose: Provides secure RDP/SSH access to VMs without public IPs
# Dependencies: Resource Group, VNet (requires AzureBastionSubnet)
# Requirements:
#   - Dedicated subnet named "AzureBastionSubnet" (minimum /26)
#   - Standard SKU Public IP
#   - VNet must be in same region as Bastion
# Best Practices:
#   - Use Bastion instead of exposing RDP/SSH ports publicly
#   - Integrate with Azure AD for authentication
#   - Enable diagnostic logging for audit trails
# Security:
#   - No public IP required on target VMs
#   - Traffic encrypted in transit
#   - Access controlled via Azure RBAC
# Cost: ~$0.19/hour + data transfer costs
# ============================================================================
module "bastion" {
  source = "../../Modules/G-Bastion"
  bastion = var.bastion
  depends_on = [module.resource_group, module.virtual_networks]
}

# ============================================================================
# MODULE: Storage Accounts
# ============================================================================
# Purpose: Creates Azure Storage Accounts and containers for blob storage
# Dependencies: Resource Group
# Features:
#   - Supports multiple containers per storage account
#   - Configurable access tiers and replication
# Best Practices:
#   - Use StorageV2 (general purpose v2) for new deployments
#   - Enable soft delete and versioning for blob storage
#   - Use Private Endpoints for secure access
#   - Enable firewall rules to restrict network access
#   - Use managed identity for authentication
# Security:
#   - Enable minimum TLS version 1.2
#   - Use Private Endpoints instead of public endpoints
#   - Enable encryption at rest (default)
#   - Use Shared Access Signatures (SAS) with limited scope
# Cost Optimization:
#   - Choose appropriate replication (LRS for dev, GRS for prod)
#   - Use lifecycle management policies for automatic tier transitions
# ============================================================================
module "storage_accounts" {
  source = "../../Modules/H-Storage-Account"
  storage_accounts = var.storage_accounts
  storage_containers = var.storage_containers
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Databases (PostgreSQL & SQL Server)
# ============================================================================
# Purpose: Creates managed database services (PostgreSQL and SQL Server)
# Dependencies: Resource Group
# Features:
#   - Supports both PostgreSQL and SQL Server
#   - Multiple databases per server
#   - Automatic backups and point-in-time restore
# Best Practices:
#   - Use Private Endpoints for secure connectivity
#   - Enable SSL/TLS enforcement
#   - Configure firewall rules to restrict access
#   - Use Azure AD authentication when possible
#   - Enable Advanced Threat Protection for production
#   - Configure automated backups and retention policies
# Security:
#   - Strong passwords (use Key Vault for storage)
#   - Enable SSL/TLS encryption in transit
#   - Use Private Endpoints to avoid public exposure
#   - Regular security updates (managed service)
# Performance:
#   - Choose appropriate SKU based on workload
#   - Monitor DTU/vCore usage and scale as needed
#   - Use connection pooling for better performance
# ============================================================================
module "databases" {
  source = "../../Modules/I-Database"
  postgresql_servers = var.postgresql_servers
  postgresql_databases = var.postgresql_databases
  sql_servers = var.sql_servers
  sql_databases = var.sql_databases
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Private Endpoints
# ============================================================================
# Purpose: Provides private connectivity to Azure PaaS services via VNet
# Dependencies: Resource Group, VNet
# Features:
#   - Dynamic private service connections (supports multiple connections)
#   - Private IP addresses in your VNet
#   - Traffic stays on Microsoft backbone network
# Best Practices:
#   - Use for all production PaaS services (Storage, Key Vault, SQL, etc.)
#   - Place in dedicated subnet for easier management
#   - Disable public network access on target services
#   - Use Private DNS zones for name resolution
# Security:
#   - Eliminates public internet exposure
#   - Traffic encrypted and private
#   - Integrates with NSG for additional security
# Cost: ~$0.01/hour per endpoint + data transfer
# ============================================================================
module "private_endpoints" {
  source = "../../Modules/J-Private-Endpoint"
  private_endpoints = var.private_endpoints
  depends_on = [module.resource_group, module.virtual_networks]
}

# ============================================================================
# MODULE: Log Analytics Workspace
# ============================================================================
# Purpose: Centralized logging and monitoring for Azure resources
# Dependencies: Resource Group
# Features:
#   - Collect logs from multiple Azure services
#   - Query logs using KQL (Kusto Query Language)
#   - Integration with Azure Monitor, Security Center, Sentinel
# Best Practices:
#   - Use single workspace per region for cost efficiency
#   - Configure appropriate retention period (30-730 days)
#   - Enable diagnostic settings on all resources
#   - Use workspace-based queries for cross-resource analysis
# Security:
#   - Enable Customer-Managed Keys (CMK) for encryption
#   - Use Private Endpoints for secure access
#   - Implement RBAC for access control
# Cost: Pay-per-GB ingested (first 5GB free per month)
# ============================================================================
module "log_analytics" {
  source = "../../Modules/K-Log-Analytics"
  log_analytics_workspaces = var.log_analytics_workspaces
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Application Gateway
# ============================================================================
# Purpose: Layer 7 load balancer with WAF (Web Application Firewall) capabilities
# Dependencies: Resource Group, VNet
# Features:
#   - Dynamic blocks for ports, listeners, rules, backend pools
#   - SSL/TLS termination
#   - URL-based routing
#   - Cookie-based session affinity
#   - WAF (Web Application Firewall) protection
# Best Practices:
#   - Use WAF_v2 SKU for production (includes WAF)
#   - Enable diagnostic logging for troubleshooting
#   - Use managed identities for Key Vault integration
#   - Configure health probes for backend health monitoring
#   - Use Private Frontend IP for internal applications
# Security:
#   - Enable WAF in Prevention mode for production
#   - Use SSL certificates from Key Vault
#   - Implement NSG rules on subnet
#   - Regular WAF rule updates
# Performance:
#   - Choose appropriate instance size and count
#   - Enable autoscaling for variable traffic
#   - Use connection draining for zero-downtime updates
# ============================================================================
module "app_gateways" {
  source = "../../Modules/L-App-Gateway"
  app_gateways = var.app_gateways
  depends_on = [module.resource_group, module.virtual_networks]
}

# ============================================================================
# MODULE: Load Balancer
# ============================================================================
# Purpose: Layer 4 load balancer for distributing traffic across VMs
# Dependencies: Resource Group
# Features:
#   - Dynamic frontend IP configurations
#   - Multiple backend pools, probes, and rules
#   - Supports both public and internal load balancing
# Best Practices:
#   - Use Standard SKU for production (better features and SLA)
#   - Configure health probes for backend health monitoring
#   - Use Availability Zones for high availability
#   - Implement proper timeout values
# Security:
#   - Use NSG rules to restrict access
#   - Consider using internal load balancer for private services
#   - Enable diagnostic logging
# Performance:
#   - Distribute load evenly across backend pool
#   - Monitor backend pool health
#   - Use appropriate probe intervals
# ============================================================================
module "load_balancers" {
  source = "../../Modules/M-Load-Balancer"
  load_balancers = var.load_balancers
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Azure Kubernetes Service (AKS)
# ============================================================================
# Purpose: Managed Kubernetes service for container orchestration
# Dependencies: Resource Group, VNet
# Features:
#   - Default node pool + additional node pools (dynamic)
#   - Azure CNI networking (advanced networking)
#   - System-assigned managed identity
#   - Integration with ACR for container images
# Best Practices:
#   - Use Azure CNI for production (better network control)
#   - Enable cluster autoscaler for cost optimization
#   - Use Availability Zones for high availability
#   - Enable Azure Policy for governance
#   - Configure RBAC and Azure AD integration
#   - Use managed identities for pod authentication
# Security:
#   - Enable Azure Policy for security compliance
#   - Use Private Cluster for production
#   - Enable Azure Defender for Kubernetes
#   - Regular Kubernetes version updates
#   - Network policies for pod-to-pod communication
# Cost Optimization:
#   - Use Spot node pools for non-critical workloads
#   - Right-size node pools based on workload
#   - Enable cluster autoscaler
# ============================================================================
module "aks_clusters" {
  source = "../../Modules/N-AKS"
  aks_clusters = var.aks_clusters
  depends_on = [module.resource_group, module.virtual_networks]
}

# ============================================================================
# MODULE: Azure Container Registry (ACR)
# ============================================================================
# Purpose: Private Docker container registry for storing container images
# Dependencies: Resource Group
# Features:
#   - Supports Docker, OCI, and Helm charts
#   - Geo-replication for global deployments
#   - Integration with AKS for seamless deployments
# Best Practices:
#   - Use Premium SKU for production (geo-replication, advanced security)
#   - Enable admin user only when necessary (prefer managed identity)
#   - Use Private Endpoints for secure access
#   - Enable content trust for image signing
#   - Implement retention policies for old images
# Security:
#   - Use managed identity for AKS integration
#   - Enable vulnerability scanning (Azure Security Center)
#   - Use Private Endpoints
#   - Implement RBAC for access control
#   - Enable soft delete for image recovery
# Cost: Pay-per-storage and operations (Basic tier starts at ~$5/month)
# ============================================================================
module "container_registries" {
  source = "../../Modules/O-ACR"
  container_registries = var.container_registries
  depends_on = [module.resource_group]
}

# ============================================================================
# MODULE: Application Security Groups (ASG)
# ============================================================================
# Purpose: Logical grouping of VMs for simplified NSG rule management
# Dependencies: Resource Group
# Features:
#   - Group VMs by application tier (web, app, db)
#   - Reference ASG in NSG rules instead of individual IPs
#   - Simplifies network security management
# Best Practices:
#   - Create ASGs by application tier (e.g., WebTier, AppTier, DataTier)
#   - Use ASGs in NSG rules for maintainability
#   - Combine with Service Tags for comprehensive rules
# Security:
#   - Use ASGs to implement micro-segmentation
#   - Easier to audit and maintain security rules
#   - Reduces risk of misconfiguration
# Example: Allow traffic from WebTier ASG to AppTier ASG on port 8080
# ============================================================================
module "application_security_groups" {
  source = "../../Modules/P-ASG"
  application_security_groups = var.application_security_groups
  depends_on = [module.resource_group]
}

