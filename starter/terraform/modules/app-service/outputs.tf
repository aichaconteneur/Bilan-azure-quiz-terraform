output "default_hostname" {
  value = azurerm_linux_web_app.backend.default_hostname
}

output "principal_id" {
  value = azurerm_linux_web_app.backend.identity[0].principal_id
}

output "app_service_name" {
  value = azurerm_linux_web_app.backend.name
}
