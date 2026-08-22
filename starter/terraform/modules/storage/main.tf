resource "azurerm_storage_account" "sa" {
  name                     = "st${replace(var.owner, "-", "")}quiz"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  # Storage accessible via Private Endpoint uniquement.
  public_network_access_enabled = false

  tags = merge(var.tags, {
    component = "storage"
  })
}

resource "azurerm_storage_container" "exports" {
  name                  = "quiz-exports"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pe-storage-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-storage-blob"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-blob-dns"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = merge(var.tags, {
    component = "storage-private-endpoint"
  })
}
