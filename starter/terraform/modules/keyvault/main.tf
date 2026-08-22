data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = "kv-aicha-dev"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  rbac_authorization_enabled = true

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  # TEMPORAIRE :
  # on laisse true pour que Terraform lancé depuis ton PC puisse créer
  # les secrets pendant cette phase.
  public_network_access_enabled = true

  tags = merge(var.tags, {
    component = "keyvault"
  })
}

resource "azurerm_private_endpoint" "keyvault" {
  name                = "pe-keyvault-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-keyvault-${var.project}-${var.environment}"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "keyvault-dns"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = merge(var.tags, {
    component = "keyvault-private-endpoint"
  })
}
