data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "container_registry" {
  source = "./modules/container-registry"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = local.tags
}

module "keyvault" {
  source = "./modules/keyvault"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  private_dns_zone_id        = module.network.keyvault_private_dns_zone_id

  tags = local.tags
}

module "postgres" {
  source = "./modules/postgres"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  postgres_version = var.postgres_version
  sku_name         = var.postgres_sku_name
  storage_mb       = var.postgres_storage_mb

  admin_username = var.postgres_admin_username
  admin_password = var.postgres_admin_password

  database_name = var.postgres_database_name

  delegated_subnet_id = module.network.postgres_subnet_id
  private_dns_zone_id = module.network.postgres_private_dns_zone_id

  tags = local.tags
}
module "redis" {
  source = "./modules/redis"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name = var.redis_sku_name

  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  redis_private_dns_zone_id  = module.network.redis_private_dns_zone_id

  tags = local.tags
}
module "storage" {
  source = "./modules/storage"

  owner               = var.owner
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  private_dns_zone_id        = module.network.storage_blob_private_dns_zone_id

  tags = local.tags
}
module "network" {
  source = "./modules/network"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = local.tags
}

module "app_service" {
  source = "./modules/app-service"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  service_plan_name                = var.shared_plan_name
  service_plan_resource_group_name = var.shared_rg_name

  container_registry_login_server = module.container_registry.login_server
  docker_image_name               = var.backend_docker_image

  keyvault_name        = module.keyvault.keyvault_name
  postgres_host        = module.postgres.postgres_fqdn
  redis_host           = module.redis.redis_hostname
  storage_account_name = module.storage.storage_account_name

  app_service_subnet_id = module.network.app_service_subnet_id

  frontend_url = "https://${module.static_web_app.static_web_app_url}"

  tags = local.tags
}

module "static_web_app" {
  source = "./modules/static-web-app"

  project             = var.project
  environment         = var.environment
  location            = "westeurope"
  resource_group_name = data.azurerm_resource_group.rg.name

  sku = var.static_webapp_sku

  tags = local.tags
}

#module "federated_credential" {
# source = "./modules/federated-credential"
#
# project           = var.project
#environment       = var.environment
#github_repository = var.github_repository
#github_branch     = var.github_branch
#
# resource_group_id = data.azurerm_resource_group.rg.id
#}

resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = module.app_service.principal_id
}

resource "azurerm_role_assignment" "app_storage_blob" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.app_service.principal_id
}

resource "azurerm_role_assignment" "app_keyvault_secrets" {
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service.principal_id
}

resource "azurerm_key_vault_secret" "postgres_username" {
  name         = "postgres-username"
  value        = var.postgres_admin_username
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = var.postgres_admin_password
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "redis_password" {
  name         = "redis-password"
  value        = module.redis.redis_primary_access_key
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "postgres_host" {
  name         = "postgres-host"
  value        = module.postgres.postgres_fqdn
  key_vault_id = module.keyvault.keyvault_id

  tags = local.tags
}

resource "azurerm_key_vault_secret" "postgres_jdbc_url" {
  name         = "postgres-jdbc-url"
  value        = "jdbc:postgresql://${module.postgres.postgres_fqdn}:5432/${var.postgres_database_name}?sslmode=require"
  key_vault_id = module.keyvault.keyvault_id

  tags = local.tags
}

resource "random_password" "backend_api_key" {
  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "backend_api_key" {
  name         = "backend-api-key"
  value        = random_password.backend_api_key.result
  key_vault_id = module.keyvault.keyvault_id

  tags = local.tags
}
