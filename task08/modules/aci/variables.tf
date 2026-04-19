variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
}

variable "aci_name" {
  description = "The name of the Container Instance"
  type        = string
}

variable "aci_sku" {
  description = "The SKU for Container Instance allocation"
  type        = string
  default     = "Standard"
}

variable "image_name" {
  description = "The full image name (acr_login_server/image_name:tag)"
  type        = string
}

variable "acr_login_server" {
  description = "The login server of the Container Registry"
  type        = string
}

variable "acr_username" {
  description = "The username for ACR authentication"
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "The password for ACR authentication"
  type        = string
  sensitive   = true
}

variable "redis_url" {
  description = "The Redis hostname/URL"
  type        = string
}

variable "redis_password" {
  description = "The Redis primary access key"
  type        = string
  sensitive   = true
}

variable "cpu" {
  description = "The number of CPU cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "The amount of memory in GB"
  type        = number
  default     = 1.5
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
