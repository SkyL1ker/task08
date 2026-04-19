variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "aks_node_pool_name" {
  description = "The name of the default node pool"
  type        = string
}

variable "aks_node_pool_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "aks_node_pool_size" {
  description = "The size of nodes in the default node pool (VM type)"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "aks_node_pool_disk_type" {
  description = "The disk type for nodes (Managed or Ephemeral)"
  type        = string
  default     = "Managed"
}

variable "acr_id" {
  description = "The ID of the Container Registry to pull images from"
  type        = string
}

variable "keyvault_id" {
  description = "The ID of the Key Vault for CSI driver integration"
  type        = string
}

variable "keyvault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
