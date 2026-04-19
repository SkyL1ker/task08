variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the ACR (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "image_name" {
  description = "The name of the Docker image"
  type        = string
}

variable "git_repository_url" {
  description = "The URL of the Git repository containing the Dockerfile"
  type        = string
}

variable "git_branch" {
  description = "The Git branch to use"
  type        = string
  default     = "main"
}

variable "git_pat" {
  description = "Personal access token for Git repository access"
  type        = string
  sensitive   = true
}

variable "docker_file_path" {
  description = "The path to the Dockerfile in the repository"
  type        = string
  default     = "application/Dockerfile"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
