variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
}

variable "keyvault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "keyvault_sku" {
  description = "The SKU of the Key Vault (standard or premium)"
  type        = string
  default     = "standard"
}

variable "current_user_object_id" {
  description = "The object ID of the current user for Key Vault access"
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
