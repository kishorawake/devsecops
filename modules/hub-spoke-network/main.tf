// Declare aliased providers so connectivity and workload resources can live in separate subscriptions.
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.connectivity, azurerm.workload]
    }
  }
}

// Resource groups establish the ownership boundaries for shared connectivity and workloads.
resource "azurerm_resource_group" "connectivity" {
  provider = azurerm.connectivity

  name     = "rg-${var.name_prefix}-connectivity"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "workload" {
  provider = azurerm.workload

  name     = "rg-${var.name_prefix}-workload"
  location = var.location
  tags     = var.tags
}

// Create the hub and workload spoke virtual networks.
resource "azurerm_virtual_network" "hub" {
  provider = azurerm.connectivity

  name                = "vnet-${var.name_prefix}-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.hub_address_space
  tags                = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  provider = azurerm.workload

  name                = "vnet-${var.name_prefix}-spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.workload.name
  address_space       = var.spoke_address_space
  tags                = var.tags
}

// Create independently configurable subnets in each virtual network.
resource "azurerm_subnet" "hub" {
  provider = azurerm.connectivity

  for_each = var.hub_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = each.value
}

resource "azurerm_subnet" "spoke" {
  provider = azurerm.workload

  for_each = var.spoke_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.workload.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = each.value
}

// Apply the workload NSG consistently to each spoke subnet.
resource "azurerm_network_security_group" "spoke" {
  provider = azurerm.workload

  name                = "nsg-${var.name_prefix}-spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.workload.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "spoke" {
  provider = azurerm.workload

  for_each = azurerm_subnet.spoke

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.spoke.id
}

// Establish bidirectional hub-to-spoke connectivity without creating public endpoints.
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.connectivity

  name                      = "peer-${var.name_prefix}-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.connectivity.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  provider = azurerm.workload

  name                      = "peer-${var.name_prefix}-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.workload.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

// Send VNet metrics to the existing Log Analytics workspace when configured.
resource "azurerm_monitor_diagnostic_setting" "hub" {
  provider = azurerm.connectivity

  count = var.log_analytics_workspace_id == null ? 0 : 1

  name                       = "diag-${var.name_prefix}-hub-vnet"
  target_resource_id         = azurerm_virtual_network.hub.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "spoke" {
  provider = azurerm.workload

  count = var.log_analytics_workspace_id == null ? 0 : 1

  name                       = "diag-${var.name_prefix}-spoke-vnet"
  target_resource_id         = azurerm_virtual_network.spoke.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}
