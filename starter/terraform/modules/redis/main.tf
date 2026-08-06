resource "azurerm_managed_redis" "redis" {
  name                = "redis-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  default_database {}

  tags = var.tags
}
