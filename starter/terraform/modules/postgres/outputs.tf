output "postgres_server_name" {
  value = azurerm_postgresql_flexible_server.postgres.name
}

output "postgres_server_id" {
  value = azurerm_postgresql_flexible_server.postgres.id
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}

output "admin_username" {
  value = var.admin_username
}
