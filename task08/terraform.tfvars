# Azure subscription and basic configuration
subscription_id       = "f4fa8263-431e-4191-8cf6-ede1f3fe028a"
location              = "East US"
resources_name_prefix = "cmtr-j2bdqggt-mod8"
student_email         = "maksym_tarasenko1@epam.com"

# Redis Cache configuration
redis_sku        = "Basic"
redis_sku_family = "C"
redis_capacity   = 2

# Key Vault configuration
keyvault_sku = "standard"

# ACR configuration
acr_sku           = "Basic"
acr_admin_enabled = true

# ACI configuration
aci_sku = "Standard"

# AKS configuration
aks_node_pool_count     = 1
aks_node_pool_size      = "Standard_D2ads_v6"
aks_node_pool_disk_type = "Ephemeral"

# Application configuration
image_name = "cmtr-j2bdqggt-mod8-app"

# Git repository (provide your repository URL)
git_repository_url = "https://gitlab.com/maxtarasenko.0500/task08.git"

# Git PAT (provide as environment variable TF_VAR_git_pat or during terraform apply)
git_pat = "glpat-wR6kTN62E1VXMm9sWEmM7mM6MQpvOjEKdTo3MWNkOA8.01.171myhhfc"
