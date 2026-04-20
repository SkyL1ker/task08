variable "name" {
  type        = string
  description = "Name of the resource"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "acr_server" {
  type        = string
  description = "ACR Login Server"
}

variable "acr_username" {
  type        = string
  description = "ACR Username"
}

variable "acr_password" {
  type        = string
  description = "ACR Password"
}

variable "redis_url" {
  type        = string
  description = "Redis URL"
}

variable "redis_pwd" {
  type        = string
  description = "Redis Password"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}