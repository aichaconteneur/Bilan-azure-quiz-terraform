resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = ["10.0.0.0/16"]

  tags = var.tags
}

############################################################
# Subnet App Service
############################################################

resource "azurerm_subnet" "app_service" {
  name                 = "snet-appservice"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [
    "10.0.1.0/24"
  ]

  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "appservice"

    service_delegation {
      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

############################################################
# Subnet PostgreSQL
############################################################

resource "azurerm_subnet" "postgres" {
  name                 = "snet-postgres"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [
    "10.0.2.0/24"
  ]

  service_endpoints = [
    "Microsoft.Storage"
  ]

  delegation {
    name = "postgres"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

############################################################
# Subnet Private Endpoints
############################################################

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [
    "10.0.3.0/24"
  ]

  private_endpoint_network_policies = "Disabled"
}

############################################################
# Private DNS Zone PostgreSQL
############################################################

resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name

  virtual_network_id = azurerm_virtual_network.vnet.id

  registration_enabled = false
}

############################################################
# Private DNS Zone Azure Managed Redis
############################################################

resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.azure.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  registration_enabled = false
}

############################################################
# Private DNS Zone Storage Blob
############################################################

resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    component = "private-dns-storage"
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob" {
  name                  = "storage-blob-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false

  tags = merge(var.tags, {
    component = "private-dns-link-storage"
  })
}

############################################################
# Private DNS Zone Key Vault
############################################################

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    component = "private-dns-keyvault"
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "keyvault-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false

  tags = merge(var.tags, {
    component = "private-dns-link-keyvault"
  })
}
