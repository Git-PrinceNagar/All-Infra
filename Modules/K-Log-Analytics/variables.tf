variable "log_analytics_workspaces" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
    tags                = optional(map(string), {})
  }))
}

