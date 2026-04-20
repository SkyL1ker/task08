data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = local.keyvault_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  tags                = local.tags
}

module "redis" {
  source              = "./modules/redis"
  name                = local.redis_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  keyvault_id         = module.keyvault.id
  tags                = local.tags
  depends_on          = [module.keyvault]
}

module "acr" {
  source              = "./modules/acr"
  name                = local.acr_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  git_pat             = var.git_pat
  git_repo_url        = var.git_repo_url
  tags                = local.tags
}

module "aks" {
  source              = "./modules/aks"
  name                = local.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  acr_id              = module.acr.id
  keyvault_id         = module.keyvault.id
  tags                = local.tags
  depends_on          = [module.acr, module.keyvault]
}

module "aci" {
  source              = "./modules/aci"
  name                = local.aci_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  acr_server          = module.acr.login_server
  acr_username        = module.acr.admin_username
  acr_password        = module.acr.admin_password
  redis_url           = module.redis.hostname
  redis_pwd           = module.redis.primary_key
  tags                = local.tags
  # depends_on          = [null_resource.trigger_acr_build]
}

# --- K8S Manifests ---

resource "kubectl_manifest" "secret_provider" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.kv_identity_client_id
    kv_name                    = local.keyvault_name
    tenant_id                  = data.azurerm_client_config.current.tenant_id
    redis_url_secret_name      = "redis-hostname"
    redis_password_secret_name = "redis-primary-key"
  })
  depends_on = [module.aks]
}

resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.module}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = module.acr.login_server
    app_image_name   = "cmtr-j2bdqggt-mod8-app"
    image_tag        = "latest"
  })

  # Removed the null_resource from this list, kept secret_provider!
  depends_on = [kubectl_manifest.secret_provider]

  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
}

resource "kubectl_manifest" "service" {
  yaml_body  = file("${path.module}/k8s-manifests/service.yaml")
  depends_on = [kubectl_manifest.deployment]
}

data "kubernetes_service" "app_service" {
  metadata {
    name = "redis-flask-app-service"
  }
  depends_on = [kubectl_manifest.service]
}