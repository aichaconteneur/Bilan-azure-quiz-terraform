resource "azurerm_static_web_app" "frontend" {
  name                = "swa-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_tier = var.sku
  sku_size = var.sku

  tags = merge(var.tags, {
    component = "frontend"
  })

  lifecycle {
    ignore_changes = [
      repository_url,
      repository_branch
    ]
  }
}
