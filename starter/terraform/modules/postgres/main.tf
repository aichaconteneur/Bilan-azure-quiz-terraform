resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "psql-${var.project}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  version    = var.postgres_version
  sku_name   = var.sku_name
  storage_mb = var.storage_mb

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  zone = "1"

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  # Désactive l'accès public : obligatoire avec un subnet délégué
  public_network_access_enabled = false

  tags = merge(var.tags, {
    component = "postgres"
  })
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgres.id

  charset   = "UTF8"
  collation = "en_US.utf8"

}
