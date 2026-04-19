resource "azurerm_redis_cache" "redis" {
  name                    = var.redis_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  capacity                = var.redis_capacity
  family                  = var.redis_sku_family
  sku_name                = var.redis_sku
  non_ssl_port_enabled    = false
  minimum_tls_version     = "1.2"

  tags = var.tags

  # Redis SSL port is 6380
  # Redis allows SSL connections on port 6380
}

# Store Redis hostname in Key Vault
resource "azurerm_key_vault_secret" "redis_hostname" {
  name            = "redis-hostname"
  value           = azurerm_redis_cache.redis.hostname
  key_vault_id    = var.keyvault_id

  depends_on = [azurerm_redis_cache.redis]
}

# Store Redis primary access key in Key Vault
resource "azurerm_key_vault_secret" "redis_primary_key" {
  name            = "redis-primary-key"
  value           = azurerm_redis_cache.redis.primary_access_key
  key_vault_id    = var.keyvault_id

  depends_on = [azurerm_redis_cache.redis]
}
