resource "azurerm_public_ip" "lb_pip" {
  for_each            = var.load_balancers
  name                = "${each.value.name}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = "Standard"
}

resource "azurerm_lb" "load_balancer" {
  for_each            = var.load_balancers
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id != null ? frontend_ip_configuration.value.public_ip_address_id : azurerm_public_ip.lb_pip[each.key].id
      subnet_id            = frontend_ip_configuration.value.subnet_id
      private_ip_address   = frontend_ip_configuration.value.private_ip_address
    }
  }

  tags = each.value.tags
}

locals {
  flattened_backend_pools = {
    for item in flatten([
      for lb_key, lb_value in var.load_balancers : [
        for pool_key, pool in lb_value.backend_address_pools : {
          key            = "${lb_key}-${pool_key}"
          loadbalancer_id = azurerm_lb.load_balancer[lb_key].id
          name            = pool.name
        }
      ]
    ]) : item.key => {
      loadbalancer_id = item.loadbalancer_id
      name            = item.name
    }
  }

  flattened_probes = {
    for item in flatten([
      for lb_key, lb_value in var.load_balancers : [
        for probe_key, probe in lb_value.probes : {
          key                = "${lb_key}-${probe_key}"
          loadbalancer_id    = azurerm_lb.load_balancer[lb_key].id
          name               = probe.name
          port               = probe.port
          protocol           = probe.protocol
          interval_in_seconds = probe.interval_in_seconds
          number_of_probes   = probe.number_of_probes
        }
      ]
    ]) : item.key => {
      loadbalancer_id    = item.loadbalancer_id
      name               = item.name
      port               = item.port
      protocol           = item.protocol
      interval_in_seconds = item.interval_in_seconds
      number_of_probes   = item.number_of_probes
    }
  }

  flattened_rules = {
    for item in flatten([
      for lb_key, lb_value in var.load_balancers : [
        for rule_key, rule in lb_value.rules : {
          key                       = "${lb_key}-${rule_key}"
          loadbalancer_id            = azurerm_lb.load_balancer[lb_key].id
          name                       = rule.name
          protocol                   = rule.protocol
          frontend_port              = rule.frontend_port
          backend_port               = rule.backend_port
          frontend_ip_configuration_name = rule.frontend_ip_configuration_name
          backend_address_pool_id    = azurerm_lb_backend_address_pool.backend_pool["${lb_key}-${rule.backend_address_pool_name}"].id
          probe_id                   = azurerm_lb_probe.lb_probe["${lb_key}-${rule.probe_name}"].id
        }
      ]
    ]) : item.key => {
      loadbalancer_id            = item.loadbalancer_id
      name                       = item.name
      protocol                   = item.protocol
      frontend_port              = item.frontend_port
      backend_port               = item.backend_port
      frontend_ip_configuration_name = item.frontend_ip_configuration_name
      backend_address_pool_id    = item.backend_address_pool_id
      probe_id                   = item.probe_id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  for_each        = local.flattened_backend_pools
  loadbalancer_id = each.value.loadbalancer_id
  name            = each.value.name
}

resource "azurerm_lb_probe" "lb_probe" {
  for_each            = local.flattened_probes
  loadbalancer_id     = each.value.loadbalancer_id
  name                = each.value.name
  port                = each.value.port
  protocol            = each.value.protocol
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each                       = local.flattened_rules
  loadbalancer_id                = each.value.loadbalancer_id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [each.value.backend_address_pool_id]
  probe_id                       = each.value.probe_id
}

