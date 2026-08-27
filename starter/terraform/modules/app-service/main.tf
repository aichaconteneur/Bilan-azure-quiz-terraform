data "azurerm_service_plan" "plan" {
  name                = var.service_plan_name
  resource_group_name = var.service_plan_resource_group_name
}

resource "azurerm_linux_web_app" "backend" {
  name                = "app-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = data.azurerm_service_plan.plan.id

  virtual_network_subnet_id = var.app_service_subnet_id

  https_only = true

  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                               = true
    minimum_tls_version                     = "1.2"
    container_registry_use_managed_identity = true
    vnet_route_all_enabled                  = true

    application_stack {
      docker_image_name   = var.docker_image_name
      docker_registry_url = "https://${var.container_registry_login_server}"
    }
  }

  app_settings = {
    WEBSITES_PORT                       = "8080"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"

    KEYVAULT_NAME          = var.keyvault_name
    SPRING_PROFILES_ACTIVE = "prod"

    FRONTEND_URL = var.frontend_url

    SPRING_DATASOURCE_URL      = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=postgres-jdbc-url)"
    SPRING_DATASOURCE_USERNAME = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=postgres-username)"
    SPRING_DATASOURCE_PASSWORD = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=postgres-password)"

    BACKEND_API_KEY = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=backend-api-key)"

    POSTGRES_HOST = var.postgres_host

    REDIS_HOSTNAME    = var.redis_host
    REDIS_PORT        = "10000"
    REDIS_SSL_ENABLED = "true"
    REDIS_PASSWORD    = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=redis-password)"

    STORAGE_ACCOUNT_NAME = var.storage_account_name
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name
    ]
  }

  tags = merge(var.tags, {
    component = "backend"
  })
}
