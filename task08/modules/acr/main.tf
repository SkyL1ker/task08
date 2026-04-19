resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = true

  tags = var.tags
}

# ACR Task to build Docker image from Git repository
resource "azurerm_container_registry_task" "build_task" {
  name                  = "${var.image_name}-build-task"
  container_registry_id = azurerm_container_registry.acr.id
  enabled               = true
  timeout_in_seconds    = 3600

  docker_step {
    dockerfile_path      = "task08/application/Dockerfile"
    context_path         = "${var.git_repository_url}#${var.git_branch}"
    context_access_token = var.git_pat
    image_names          = ["${var.image_name}:latest"]
  }

  platform {
    os = "Linux"
  }
}

# ACR Task Schedule (optional - triggers build on schedule)
resource "azurerm_container_registry_task_schedule_run_now" "build_now" {
  container_registry_task_id = azurerm_container_registry_task.build_task.id
}
