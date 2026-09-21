// Return IDs needed by private endpoints, route tables, and application landing zones.
output "hub_virtual_network_id" {
  description = "Hub VNet resource ID."
  value       = azurerm_virtual_network.hub.id
}

output "spoke_virtual_network_id" {
  description = "Spoke VNet resource ID."
  value       = azurerm_virtual_network.spoke.id
}

output "hub_subnet_ids" {
  description = "Hub subnet resource IDs."
  value       = { for name, subnet in azurerm_subnet.hub : name => subnet.id }
}

output "spoke_subnet_ids" {
  description = "Spoke subnet resource IDs."
  value       = { for name, subnet in azurerm_subnet.spoke : name => subnet.id }
}
