output "kv_identity_client_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0]
  sensitive = true
}