output "acr_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "The name of the Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "The login server of the Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "build_task_id" {
  description = "The ID of the build task"
  value       = azurerm_container_registry_task.build_task.id
}

output "admin_username" {
  description = "The admin username for the Container Registry"
  value       = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  description = "The admin password for the Container Registry"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}
