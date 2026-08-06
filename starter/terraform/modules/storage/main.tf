resource "azurerm_storage_account" "sa" {
  name                     = "st${replace(var.owner, "-", "")}quiz"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_container" "exports" {
  name                  = "quiz-exports"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}
