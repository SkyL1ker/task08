output "id" { value = azurerm_container_registry.acr.id }
output "login_server" { value = azurerm_container_registry.acr.login_server }
output "admin_username" { value = azurerm_container_registry.acr.admin_username }
output "admin_password" { value = azurerm_container_registry.acr.admin_password }
output "task_name" { value = azurerm_container_registry_task.task.name }