variable "name_prefix" {
  type        = string
  default     = "cmtr-j2bdqggt-mod8"
  description = "Prefix for resource names"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure Region"
}

variable "git_pat" {
  type        = string
  sensitive   = true
  description = "Personal access token for the repository where source code is located"
}

variable "git_repo_url" {
  type        = string
  description = "URL of your Git repository containing the task08/application folder (e.g., https://github.com/your-username/repo.git)"
}