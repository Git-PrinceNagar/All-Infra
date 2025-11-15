variable "storage_accounts" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    min_tls_version          = optional(string, "TLS1_2")
    tags                     = optional(map(string), {})
  }))
}

variable "storage_containers" {
  type = map(object({
    name                  = string
    storage_account_key   = string
    container_access_type = optional(string, "private")
  }))
  default = {}
}

