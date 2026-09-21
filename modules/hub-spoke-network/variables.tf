// Naming, location, address space, and subnet inputs define the reusable network contract.
variable "name_prefix" {
  description = "CAF-compliant name prefix."
  type        = string
}

variable "location" {
  description = "Azure region for the network resources."
  type        = string
}

variable "hub_address_space" {
  description = "Hub VNet address spaces."
  type        = list(string)
}

variable "spoke_address_space" {
  description = "Spoke VNet address spaces."
  type        = list(string)
}

variable "hub_subnets" {
  description = "Hub subnet names and prefixes."
  type        = map(list(string))
}

variable "spoke_subnets" {
  description = "Spoke subnet names and prefixes."
  type        = map(list(string))
}

// Diagnostics remain optional because brownfield estates may have an existing monitoring module.
variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace resource ID for VNet diagnostics."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Enterprise tags."
  type        = map(string)
}
