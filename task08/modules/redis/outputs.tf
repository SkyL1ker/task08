output "redis_id" {
  description = "The ID of the Redis cache"
  value       = azurerm_redis_cache.redis.id
}

output "redis_hostname" {
  description = "The hostname of the Redis cache"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_port" {
  description = "The SSL port of the Redis cache"
  value       = 6380
}

output "redis_primary_key" {
  description = "The primary access key of the Redis cache"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "redis_hostname_secret_id" {
  description = "The ID of the Redis hostname secret in Key Vault"
  value       = azurerm_key_vault_secret.redis_hostname.id
}

output "redis_primary_key_secret_id" {
  description = "The ID of the Redis primary key secret in Key Vault"
  value       = azurerm_key_vault_secret.redis_primary_key.id
}
