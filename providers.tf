// Default provider targets the shared connectivity subscription.
provider "azurerm" {
  features {}

  subscription_id = var.connectivity_subscription_id
  tenant_id       = var.tenant_id
}

// Provider alias targets the workload subscription for spoke resources.
provider "azurerm" {
  alias = "workload"

  features {}

  subscription_id = var.workload_subscription_id
  tenant_id       = var.tenant_id
}
