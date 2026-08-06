data "azurerm_service_plan" "plan" {
  name                = var.service_plan_name
  resource_group_name = var.service_plan_resource_group_name
}

resource "azurerm_linux_web_app" "backend" {
  name                = "app-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = data.azurerm_service_plan.plan.id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                               = true
    minimum_tls_version                     = "1.2"
    container_registry_use_managed_identity = true

    application_stack {
      docker_image_name   = var.docker_image_name
      docker_registry_url = "https://${var.container_registry_login_server}"
    }
  }

  app_settings = {
    WEBSITES_PORT          = "8080"
    KEYVAULT_NAME          = var.keyvault_name
    SPRING_PROFILES_ACTIVE = var.environment
    POSTGRES_HOST          = var.postgres_host
    REDIS_HOST             = var.redis_host
    STORAGE_ACCOUNT_NAME   = var.storage_account_name
  }

  tags = var.tags
}
