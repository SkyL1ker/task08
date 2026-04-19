variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
  default     = "East US"
}

variable "resources_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "student_email" {
  description = "The student email for resource tags"
  type        = string
}

variable "redis_sku" {
  description = "The SKU of Azure Cache for Redis"
  type        = string
  default     = "Basic"
}

variable "redis_sku_family" {
  description = "The SKU family of Redis (C for Basic/Standard, P for Premium)"
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "The capacity of Redis (0 for Basic)"
  type        = number
  default     = 0
}

variable "keyvault_sku" {
  description = "The SKU of the Key Vault"
  type        = string
  default     = "standard"
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "aci_sku" {
  description = "The SKU for Container Instance"
  type        = string
  default     = "Standard"
}

variable "aks_node_pool_count" {
  description = "The number of nodes in the AKS default node pool"
  type        = number
  default     = 1
}

variable "aks_node_pool_size" {
  description = "The size of nodes in the AKS default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "aks_node_pool_disk_type" {
  description = "The disk type for AKS nodes"
  type        = string
  default     = "Managed"
}

variable "image_name" {
  description = "The name of the Docker image"
  type        = string
  default     = "redis-flask-app"
}

variable "git_repository_url" {
  description = "The URL of the Git repository containing the Dockerfile"
  type        = string
  default     = ""
}

variable "git_pat" {
  description = "Personal access token for Git repository access"
  type        = string
  sensitive   = true
}

variable "acr_admin_enabled" {
  description = "Whether admin user is enabled for ACR"
  type        = bool
  default     = false
}
