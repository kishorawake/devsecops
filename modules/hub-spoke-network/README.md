# Hub and Spoke Network Module

## Architecture

This module creates a connectivity resource group, workload resource group, hub VNet, spoke VNet, subnets, spoke NSG association, bidirectional peering, and optional VNet diagnostics to an existing Log Analytics workspace.

## Brownfield Use

The module is intended to be enabled only after discovery confirms that the target names and address spaces are available. Existing resources must be imported into the matching Terraform addresses before any additive deployment. Do not enable creation against an existing resource without an import plan and a no-change Terraform plan.

## AVM Decision

The initial module uses native `azurerm` resources because the brownfield onboarding contract requires stable, individually importable resource addresses and the module deliberately exposes only the resource surface needed for this baseline. AVM adoption should be evaluated per resource during refactoring; any replacement must be proven no-op with an import and plan comparison before merging.

## Security

No public IPs or public endpoints are created. NSG rules are intentionally supplied by a later security module so that enterprise ingress and egress policy is reviewed centrally. Diagnostics require an existing Log Analytics workspace.

## Limitations

Cross-subscription peering, Azure Firewall, VPN or ExpressRoute gateways, route tables, Private DNS, and policy assignments are separate platform modules and are not created by this first onboarding slice.
