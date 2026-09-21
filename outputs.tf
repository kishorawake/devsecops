// Expose network identifiers to later platform and application modules.
output "hub_virtual_network_id" {
  description = "Resource ID of the managed hub virtual network."
  value       = try(module.hub_spoke_network[0].hub_virtual_network_id, null)
}

output "spoke_virtual_network_id" {
  description = "Resource ID of the managed workload spoke virtual network."
  value       = try(module.hub_spoke_network[0].spoke_virtual_network_id, null)
}

output "hub_subnet_ids" {
  description = "Managed hub subnet resource IDs keyed by subnet name."
  value       = try(module.hub_spoke_network[0].hub_subnet_ids, {})
}

output "spoke_subnet_ids" {
  description = "Managed spoke subnet resource IDs keyed by subnet name."
  value       = try(module.hub_spoke_network[0].spoke_subnet_ids, {})
}
