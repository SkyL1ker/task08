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
variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}
variable "object_id" {
  type        = string
  description = "Azure Object ID"
}
variable "tags" {
  type        = map(string)
  description = "Resource tags"
}