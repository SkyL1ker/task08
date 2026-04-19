# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

# Redis Outputs
output "redis_hostname" {
  description = "The hostname of the Redis cache"
  value       = module.redis.redis_hostname
}

output "redis_port" {
  description = "The SSL port of the Redis cache"
  value       = module.redis.redis_port
}

# Key Vault Outputs
output "keyvault_name" {
  description = "The name of the Key Vault"
  value       = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  description = "The URI of the Key Vault"
  value       = module.keyvault.keyvault_uri
}

# ACR Outputs
output "acr_login_server" {
  description = "The login server of the Container Registry"
  value       = module.acr.acr_login_server
}

output "acr_name" {
  description = "The name of the Container Registry"
  value       = module.acr.acr_name
}

# ACI Outputs (as required in task)
output "aci_fqdn" {
  description = "FQDN of App in Azure Container Instance"
  value       = module.aci.aci_fqdn
}

output "aci_ip_address" {
  description = "The IP address of the Container Instance"
  value       = module.aci.aci_ip_address
}

# AKS Outputs
output "aks_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_name
}

output "aks_oidc_issuer_url" {
  description = "The OIDC issuer URL of the AKS cluster"
  value       = module.aks.aks_oidc_issuer_url
}

# Kubernetes Service Output (as required in task)
output "aks_lb_ip" {
  description = "Load Balancer IP address of APP in AKS"
  value       = try(data.kubernetes_service.app_service.status[0].load_balancer[0].ingress[0].ip, null)
}

# Application Access URLs
output "application_urls" {
  description = "URLs to access the application"
  value = {
    aci_url = "http://${module.aci.aci_fqdn}:8080"
    aks_url = try("http://${data.kubernetes_service.app_service.status[0].load_balancer[0].ingress[0].ip}:80", null)
  }
}
