output "aci_id" {
  description = "The ID of the Container Instance"
  value       = azurerm_container_group.aci.id
}

output "aci_fqdn" {
  description = "The FQDN of the Container Instance"
  value       = azurerm_container_group.aci.fqdn
}

output "aci_ip_address" {
  description = "The IP address of the Container Instance"
  value       = azurerm_container_group.aci.ip_address
}
