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
variable "acr_id" {
  type        = string
  description = "ACR ID"
}
variable "keyvault_id" {
  type        = string
  description = "Key Vault ID"
}
variable "tags" {
  type        = map(string)
  description = "Resource tags"
}