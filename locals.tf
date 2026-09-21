// Centralize CAF naming and enterprise tags so modules receive consistent metadata.
locals {
  name_prefix = "${var.workload_name}-${var.environment}-${var.location_short}"

  tags = merge(
    {
      Environment        = var.environment
      Application        = var.workload_name
      Owner              = "platform-engineering"
      BusinessUnit       = "platform"
      CostCenter         = "unassigned"
      Criticality        = var.environment == "prd" ? "high" : "medium"
      DataClassification = "internal"
      ManagedBy          = "Terraform"
      Repository         = "TerraformMigrate"
      Version            = "1.0.0"
    },
    var.tags
  )
}
