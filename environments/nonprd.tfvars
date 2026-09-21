# Non-production values are safe, committed workload settings; secrets and IDs come from GitHub.
environment       = "nonprd"
location          = "eastus"
location_short    = "eus"
workload_name     = "platform"
create_foundation = false

tags = {
  CostCenter = "CC0000"
}
