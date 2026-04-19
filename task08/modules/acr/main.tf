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
    dockerfile_path      = "Dockerfile" 
    context_path         = "${var.git_repo_url}#master:application"
    context_access_token = var.git_pat
    image_names          = ["cmtr-j2bdqggt-mod8-app:latest"]
  }

  # The timer_trigger block must be inside the task resource
  timer_trigger {
    name     = "daily-build"
    schedule = "0 0 * * *"
    enabled  = true
  }
}