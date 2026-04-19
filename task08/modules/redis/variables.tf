variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
}

variable "redis_name" {
  description = "The name of the Azure Cache for Redis"
  type        = string
}

variable "redis_sku" {
  description = "The SKU (Basic, Standard, Premium)"
  type        = string
}

variable "redis_sku_family" {
  description = "The SKU family (C for Basic/Standard, P for Premium)"
  type        = string
}

variable "redis_capacity" {
  description = "The capacity of the Redis cache (0-1 for Basic, 0-6 for Standard/Premium)"
  type        = number
}

variable "keyvault_id" {
  description = "The ID of the Key Vault to store secrets"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
