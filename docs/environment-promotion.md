# Environment and Subscription Promotion

Each environment is a separate Terraform execution and state key. The committed files under `environments/` contain only non-secret workload settings. Subscription IDs, tenant IDs, OIDC client IDs, and state settings are supplied through GitHub Environment variables.

## GitHub Environments

Create these protected environments:

- `terraform-nonprd-plan`
- `terraform-nonprd-apply`
- `terraform-prd-plan`
- `terraform-prd-apply`

Set the following variables on each environment:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `CONNECTIVITY_SUBSCRIPTION_ID`
- `WORKLOAD_SUBSCRIPTION_ID`
- `TF_STATE_STORAGE_ACCOUNT`
- `TF_STATE_CONTAINER`

Configure required reviewers on `terraform-prd-apply`. The federated credential subject must match the repository and the `main` branch or the protected deployment environment according to the organization’s GitHub OIDC policy.

Required repository branch rules are documented in `docs/github-repository-controls.md`. These rules are mandatory for production and prevent direct pushes from bypassing pull-request review.

## Execution

Pull requests run formatting, Terraform validation, TFLint, tfsec, Checkov, Trivy, and plans for both environments. A merge to `main` creates and applies the exact saved plan for non-production, then waits for the protected production environment approval before applying production.

The connectivity provider manages resources in `CONNECTIVITY_SUBSCRIPTION_ID`. The workload provider manages resources in `WORKLOAD_SUBSCRIPTION_ID`. The managed identity must have only the required resource-group or subscription-level roles in both subscriptions.

## State Isolation

The current workflow uses these backend keys:

- `nonprd/connectivity.tfstate`
- `prd/connectivity.tfstate`

Create additional root configurations and keys for identity, shared services, policies, and application landing zones rather than combining all enterprise resources into one state file.
