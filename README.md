# Azure Terraform Standardization

This repository is an import-first Terraform baseline for standardizing an existing Azure estate under CAF-aligned, pull-request-controlled infrastructure management.

## Current Scope

- Production and non-production environment parameterization
- Connectivity and workload subscription inputs
- Optional hub-and-spoke network foundation
- Existing Log Analytics diagnostics integration
- GitHub Actions OIDC-compatible workflow structure
- Brownfield import runbook
- Separate `nonprd` and `prd` environment definitions
- tfsec, Checkov, Trivy, and TFLint pipeline gates

The default configuration is non-destructive: `create_foundation = false`.

## Workflow

1. Discover and inventory existing resources.
2. Map each resource to a Terraform address and module boundary.
3. Import resources into remote state.
4. Refactor generated configuration into reusable modules.
5. Run `terraform plan` until it reports no changes.
6. Enable additive creation only for resources confirmed absent.
7. Merge through GitHub Pull Requests and apply only from GitHub Actions.

## Validation

```powershell
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

The remote backend requires an Azure Storage Account and blob container. Configure those values through `terraform init -backend-config` or the GitHub Actions environment; do not commit backend credentials.

Environment promotion and subscription routing are documented in `docs/environment-promotion.md`.

Repository protection, destructive-change approval, and action pinning are documented in `docs/github-repository-controls.md`.

## AVM Exception

The first network module uses native AzureRM resources to preserve individually importable addresses while the existing estate is inventoried. AVM adoption is an explicit refactoring gate and must be validated as a no-op transition before production use.
