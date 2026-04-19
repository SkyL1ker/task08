# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location

  tags = local.common_tags
}

# Key Vault Module
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  keyvault_name          = local.keyvault_name
  keyvault_sku           = var.keyvault_sku
  current_user_object_id = data.azurerm_client_config.current.object_id
  tenant_id              = data.azurerm_client_config.current.tenant_id

  tags = local.common_tags
}

# Redis Module (depends on Key Vault)
module "redis" {
  source = "./modules/redis"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  redis_name          = local.redis_name
  redis_sku           = var.redis_sku
  redis_sku_family    = var.redis_sku_family
  redis_capacity      = var.redis_capacity
  keyvault_id         = module.keyvault.keyvault_id

  tags = local.common_tags

  depends_on = [module.keyvault]
}

# ACR Module
module "acr" {
  source = "./modules/acr"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_name            = local.acr_name
  acr_sku             = var.acr_sku
  image_name          = var.image_name
  git_repository_url  = var.git_repository_url
  git_pat             = var.git_pat

  tags = local.common_tags
}

# ACI Module (depends on ACR and Redis)
module "aci" {
  source = "./modules/aci"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  aci_name            = local.aci_name
  image_name          = "${module.acr.acr_login_server}/${var.image_name}:latest"
  acr_login_server    = module.acr.acr_login_server
  
  # Fetching credentials directly from the module outputs now!
  acr_username        = module.acr.admin_username
  acr_password        = module.acr.admin_password
  
  redis_url           = module.redis.redis_hostname
  redis_password      = module.redis.redis_primary_key
  cpu                 = 1
  memory              = 1.5

  tags = local.common_tags

  depends_on = [module.acr, module.redis]
}

# AKS Module (depends on ACR and Key Vault)
module "aks" {
  source = "./modules/aks"

  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  aks_name                = local.aks_name
  aks_dns_prefix          = local.aks_dns_prefix
  aks_node_pool_name      = local.aks_node_pool_name
  aks_node_pool_count     = var.aks_node_pool_count
  aks_node_pool_size      = var.aks_node_pool_size
  aks_node_pool_disk_type = var.aks_node_pool_disk_type
  acr_id                  = module.acr.acr_id
  keyvault_id             = module.keyvault.keyvault_id
  keyvault_name           = module.keyvault.keyvault_name
  tenant_id               = data.azurerm_client_config.current.tenant_id

  tags = local.common_tags

  depends_on = [module.acr, module.keyvault]
}

# Wait for AKS cluster to be ready before deploying manifests
resource "time_sleep" "wait_for_aks" {
  create_duration = "30s"

  depends_on = [module.aks]
}

# Create Kubernetes service account for Workload Identity
resource "kubernetes_service_account" "app_sa" {
  metadata {
    name      = "redis-flask-app"
    namespace = "default"
    annotations = {
      "azure.workload.identity/client-id" = module.aks.aks_kv_access_identity_client_id
    }
  }

  depends_on = [time_sleep.wait_for_aks]
}

# Deploy Secret Provider Kubernetes manifest
resource "kubectl_manifest" "secret_provider" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.aks_kv_access_identity_id
    kv_name                    = module.keyvault.keyvault_name
    redis_url_secret_name      = "redis-hostname"
    redis_password_secret_name = "redis-primary-key"
    tenant_id                  = data.azurerm_client_config.current.tenant_id
  })

  depends_on = [kubernetes_service_account.app_sa]
}

# Deploy Deployment Kubernetes manifest
resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.module}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = module.acr.acr_login_server
    app_image_name   = var.image_name
    image_tag        = "latest"
  })

  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }

  depends_on = [kubectl_manifest.secret_provider]
}

# Deploy Service Kubernetes manifest
resource "kubectl_manifest" "service" {
  yaml_body = file("${path.module}/k8s-manifests/service.yaml")

  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }

  depends_on = [kubectl_manifest.deployment]
}

# Get the LoadBalancer IP address from the Service
data "kubernetes_service" "app_service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default"
  }

  depends_on = [kubectl_manifest.service]
}