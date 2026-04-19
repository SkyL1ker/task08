locals {
  # Resource naming convention
  resource_name_prefix = var.resources_name_prefix

  rg_name            = "${local.resource_name_prefix}-rg"
  keyvault_name      = "${local.resource_name_prefix}-kv"
  redis_name         = "${local.resource_name_prefix}-redis"
  acr_name           = "${replace(local.resource_name_prefix, "-", "")}cr"
  aci_name           = "${local.resource_name_prefix}-ci"
  aks_name           = "${local.resource_name_prefix}-aks"
  aks_dns_prefix     = replace(local.resource_name_prefix, "-", "")
  aks_node_pool_name = "system"

  common_tags = {
    Creator = var.student_email
  }
}

# Get current Azure context information
data "azurerm_client_config" "current" {}
