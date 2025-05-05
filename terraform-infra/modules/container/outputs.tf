output "CONTAINER_APP_URL" {
  value = "https://${azurerm_container_app.container_app.latest_revision_fqdn}"
}

output "container_app_identity" {
  value = azurerm_container_app.container_app.identity.0.principal_id # idenitty is a list
}
