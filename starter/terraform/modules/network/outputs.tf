output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "app_service_subnet_id" {
  value = azurerm_subnet.app_service.id
}

output "postgres_subnet_id" {
  value = azurerm_subnet.postgres.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "postgres_private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres.id
}

output "postgres_private_dns_zone_name" {
  value = azurerm_private_dns_zone.postgres.name
}

output "redis_private_dns_zone_id" {
  value = azurerm_private_dns_zone.redis.id
}

output "storage_blob_private_dns_zone_id" {
  value = azurerm_private_dns_zone.storage_blob.id
}

output "keyvault_private_dns_zone_id" {
  value = azurerm_private_dns_zone.keyvault.id
}
