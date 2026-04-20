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
variable "git_pat" {
  type        = string
  description = "Git Personal Access Token"
}
variable "git_repo_url" {
  type        = string
  description = "Git repository URL"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}