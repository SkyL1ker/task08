output "aci_fqdn" {
  description = "FQDN of App in Azure Container Instance"
  value       = module.aci.fqdn
}

output "aks_lb_ip" {
  description = "Load Balancer IP address of APP in AKS"
  # The try() function stops the crash if Azure hasn't assigned the IP yet
  value = try(data.kubernetes_service.app_service.status.0.load_balancer.0.ingress.0.ip, "Pending IP Assignment... run terraform apply again in 2 mins")
}