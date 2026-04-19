resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

resource "azurerm_container_registry_task" "task" {
  name                  = "build-app-task"
  container_registry_id = azurerm_container_registry.acr.id
  
  platform {
    os = "Linux"
  }
  
  docker_step {
    dockerfile_path      = "task08/application/Dockerfile"
    context_path         = var.git_repo_url
    context_access_token = var.git_pat
    image_names          = ["cmtr-j2bdqggt-mod8-app:latest"]
  }
}

resource "azurerm_container_registry_task_schedule_timer_trigger" "schedule" {
  name                       = "daily-build"
  container_registry_task_id = azurerm_container_registry_task.task.id
  schedule                   = "0 0 * * *"
  enabled                    = true
}