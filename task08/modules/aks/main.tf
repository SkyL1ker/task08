# Create user-assigned identity for Key Vault access
resource "azurerm_user_assigned_identity" "kv_access_identity" {
  name                = "${var.aks_name}-kv-access-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# AKS Cluster with CSI driver enabled for Key Vault integration
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = "1.27"

  default_node_pool {
    name                = var.aks_node_pool_name
    node_count          = var.aks_node_pool_count
    vm_size             = var.aks_node_pool_size
    os_disk_type        = var.aks_node_pool_disk_type == "Managed" ? "Managed" : "Ephemeral"
    max_pods            = 110
    zones               = ["1", "2", "3"]
    enable_auto_scaling = false
  }

  # Enable service principal or managed identity
  identity {
    type = "SystemAssigned"
  }

  # Enable OIDC issuer for Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Enable Key Vault CSI driver
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  tags = var.tags
}

# Role assignment: AKS can pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope              = var.acr_id
  role_definition_name = "AcrPull"
  principal_id       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Key Vault Access Policy for user-assigned identity (get secrets)
resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = var.keyvault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.kv_access_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}

# Federated identity credential for Workload Identity
resource "azurerm_federated_identity_credential" "aks_kv_access" {
  name                = "${var.aks_name}-kv-access"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.kv_access_identity.id
  subject             = "system:serviceaccount:default:redis-flask-app"
}
