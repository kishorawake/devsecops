// Store state remotely in Azure Storage and authenticate through Entra ID/OIDC.
terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
}
