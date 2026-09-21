// Deploy the optional network foundation only after discovery confirms resources are absent
// or have been imported into the corresponding module addresses.
module "hub_spoke_network" {
  count = var.create_foundation ? 1 : 0

  source = "./modules/hub-spoke-network"

  providers = {
    azurerm.connectivity = azurerm
    azurerm.workload     = azurerm.workload
  }

  name_prefix                = local.name_prefix
  location                   = var.location
  hub_address_space          = var.hub_address_space
  spoke_address_space        = var.spoke_address_space
  hub_subnets                = var.hub_subnets
  spoke_subnets              = var.spoke_subnets
  log_analytics_workspace_id = var.log_analytics_workspace_id
  tags                       = local.tags
}
