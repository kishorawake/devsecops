// Tenant and subscription inputs keep the root configuration portable across estates.
variable "tenant_id" {
  description = "Microsoft Entra tenant ID used by the AzureRM providers."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription ID hosting shared connectivity resources."
  type        = string
}

variable "workload_subscription_id" {
  description = "Subscription ID hosting workload resources."
  type        = string
}

// Environment and regional naming inputs drive CAF-compliant resource names.
variable "environment" {
  description = "CAF environment identifier."
  type        = string

  validation {
    condition     = contains(["prd", "nonprd"], var.environment)
    error_message = "environment must be either prd or nonprd."
  }
}

variable "location" {
  description = "Primary Azure region."
  type        = string
}

variable "location_short" {
  description = "CAF short region code used in resource names."
  type        = string
}

variable "workload_name" {
  description = "Short workload or platform name used in resource names."
  type        = string
}

// Brownfield safety switch: keep disabled until existing resources are inventoried/imported.
variable "create_foundation" {
  description = "Creates new baseline resources. Keep false during brownfield discovery and import."
  type        = bool
  default     = false
}

// Network address and subnet inputs are configurable per environment.
variable "hub_address_space" {
  description = "CIDR range for the hub virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_address_space" {
  description = "CIDR range for the workload spoke virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "hub_subnets" {
  description = "Hub subnet names and CIDR prefixes."
  type        = map(list(string))
  default = {
    AzureFirewallSubnet = ["10.0.0.0/26"]
    GatewaySubnet       = ["10.0.1.0/27"]
    snet-management     = ["10.0.10.0/24"]
  }
}

variable "spoke_subnets" {
  description = "Spoke subnet names and CIDR prefixes."
  type        = map(list(string))
  default = {
    snet-app  = ["10.10.1.0/24"]
    snet-data = ["10.10.2.0/24"]
  }
}

// Existing monitoring destination for optional diagnostic settings.
variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace resource ID for diagnostics."
  type        = string
  default     = null
  nullable    = true
}

// Caller-supplied tags override or extend the standard enterprise tag set.
variable "tags" {
  description = "CAF and enterprise tags applied to every managed resource."
  type        = map(string)
  default     = {}
}
