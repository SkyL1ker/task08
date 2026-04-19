resource "azurerm_container_group" "aci" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = var.aci_name

  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_username
    password = var.acr_password
  }

  container {
    name   = "app"
    image  = var.image_name
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = 8080
      protocol = "TCP"
    }

    # Environment variables
    environment_variables = {
      CREATOR       = "ACI"
      REDIS_PORT    = "6380"
      REDIS_SSL_MODE = "true"
    }

    # Secure environment variables
    secure_environment_variables = {
      REDIS_URL = var.redis_url
      REDIS_PWD = var.redis_password
    }
  }

  tags = var.tags
}
