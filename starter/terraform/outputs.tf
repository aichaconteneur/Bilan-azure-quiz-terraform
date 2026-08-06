output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "container_registry_name" {
  value = module.container_registry.name
}

output "container_registry_login_server" {
  value = module.container_registry.login_server
}

output "keyvault_name" {
  value = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  value = module.keyvault.keyvault_uri
}

output "postgres_server_name" {
  value = module.postgres.postgres_server_name
}

output "postgres_fqdn" {
  value = module.postgres.postgres_fqdn
}

output "postgres_database_name" {
  value = module.postgres.database_name
}

output "redis_name" {
  value = module.redis.redis_name
}

output "redis_id" {
  value = module.redis.redis_id
}

output "redis_hostname" {
  value = module.redis.redis_hostname
}

output "redis_primary_access_key" {
  value     = module.redis.redis_primary_access_key
  sensitive = true
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "storage_blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}

output "storage_container_name" {
  value = module.storage.exports_container_name
}

output "app_service_name" {
  value = module.app_service.app_service_name
}

output "backend_url" {
  value = "https://${module.app_service.default_hostname}"
}

output "app_service_principal_id" {
  value = module.app_service.principal_id
}

output "static_web_app_name" {
  value = module.static_web_app.static_web_app_name
}

output "frontend_url" {
  value = "https://${module.static_web_app.static_web_app_url}"
}

#output "github_client_id" {
# value = module.federated_credential.client_id
#}

#output "github_service_principal_object_id" {
# value = module.federated_credential.service_principal_object_id
#}
