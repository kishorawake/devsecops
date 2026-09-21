# Brownfield Import Runbook

## Preconditions

- Resource inventory exported from Azure Resource Graph
- Read access across the target subscriptions
- Terraform state storage account and private access path
- Approved resource-to-address mapping
- Backup of the current state and change record

## Process

1. Create a separate backend key for the environment and scope, such as `platform/nonprd/connectivity.tfstate`.
2. Configure provider aliases with subscription IDs supplied through the CI environment.
3. Add the resource block or module address before importing.
4. Run `terraform import` for the existing resource ID.
5. Run `terraform plan -refresh-only` and review drift.
6. Refactor the resource into a module without changing its remote identity.
7. Run a normal `terraform plan` and require zero unintended changes.
8. Merge only after security, diagnostics, tagging, and CAF checks pass.

## Example

```powershell
terraform import 'module.hub_spoke_network[0].azurerm_virtual_network.hub' '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<name>'
terraform plan -refresh-only -var-file=environments/nonprd.tfvars
terraform plan -var-file=environments/nonprd.tfvars -out=nonprd.tfplan
```

Never import a production resource into a temporary local state. Initialize the approved remote backend first.
