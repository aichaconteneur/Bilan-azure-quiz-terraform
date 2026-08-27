resource "azurerm_managed_redis" "redis" {
  name                = "redis-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  # Redis ne doit pas être accessible depuis Internet.
  public_network_access = "Disabled"

  default_database {
    # Ton Spring Boot utilise REDIS_PASSWORD.
    access_keys_authentication_enabled = true

    # TLS obligatoire.
    client_protocol = "Encrypted"
  }

  tags = merge(var.tags, {
    component = "redis"
  })
}

resource "azurerm_private_endpoint" "redis" {
  name                = "pe-redis-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-redis-${var.project}-${var.environment}"
    private_connection_resource_id = azurerm_managed_redis.redis.id
    subresource_names              = ["redisEnterprise"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "redis-dns"
    private_dns_zone_ids = [var.redis_private_dns_zone_id]
  }

  tags = merge(var.tags, {
    component = "redis-private-endpoint"
  })
}
