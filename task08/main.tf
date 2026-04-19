resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location

  tags = local.common_tags
}

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

module "redis" {
  source = "./modules/redis"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  redis_name       = local.redis_name
  redis_sku        = var.redis_sku
  redis_sku_family = var.redis_sku_family
  redis_capacity   = var.redis_capacity

  keyvault_id = module.keyvault.keyvault_id

  tags = local.common_tags

  depends_on = [module.keyvault]
}

module "acr" {
  source = "./modules/acr"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  acr_name           = local.acr_name
  acr_sku            = var.acr_sku
  image_name         = var.image_name
  git_repository_url = var.git_repository_url
  git_pat            = var.git_pat

  tags = local.common_tags
}

module "aci" {
  source = "./modules/aci"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  aci_name         = local.aci_name
  acr_login_server = module.acr.acr_login_server

  image_name    = "${module.acr.acr_login_server}/${var.image_name}:latest"
  acr_username   = module.acr.acr_admin_username
  acr_password   = module.acr.acr_admin_password

  redis_url      = module.redis.redis_hostname
  redis_password = module.redis.redis_primary_key

  cpu    = 1
  memory = 1.5

  tags = local.common_tags

  depends_on = [module.acr, module.redis]
}

module "aks" {
  source = "./modules/aks"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  aks_name           = local.aks_name
  aks_dns_prefix     = local.aks_dns_prefix

  aks_node_pool_name  = local.aks_node_pool_name
  aks_node_pool_count = var.aks_node_pool_count
  aks_node_pool_size  = var.aks_node_pool_size
  aks_node_pool_disk_type = var.aks_node_pool_disk_type

  acr_id        = module.acr.acr_id
  keyvault_id   = module.keyvault.keyvault_id
  keyvault_name = module.keyvault.keyvault_name
  tenant_id     = data.azurerm_client_config.current.tenant_id

  tags = local.common_tags

  depends_on = [module.acr, module.keyvault]
}

provider "kubectl" {
  host                   = module.aks.kube_config.host
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  load_config_file       = false
}

provider "kubernetes" {
  host                   = module.aks.kube_config.host
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
}

resource "time_sleep" "wait_for_aks" {
  create_duration = "60s"

  depends_on = [module.aks]
}

resource "kubernetes_service_account" "app_sa" {
  metadata {
    name      = "redis-flask-app"
    namespace = "default"

    annotations = {
      "azure.workload.identity/client-id" = module.aks.kv_identity_client_id
    }
  }

  depends_on = [time_sleep.wait_for_aks]
}

resource "kubectl_manifest" "secret_provider" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.kv_identity_id
    kv_name                    = module.keyvault.keyvault_name
    redis_url_secret_name     = "redis-hostname"
    redis_password_secret_name = "redis-primary-key"
    tenant_id                 = data.azurerm_client_config.current.tenant_id
  })

  depends_on = [kubernetes_service_account.app_sa]
}

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

data "kubernetes_service" "app_service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default"
  }

  depends_on = [kubectl_manifest.service]
}