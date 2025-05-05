output "COSMOSDB_ENDPOINT" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "COSMOSDB_KEY" {
  value = azurerm_cosmosdb_account.cosmosdb.primary_key
}

output "COSMOSDB_DATABASE" {
  value = azurerm_cosmosdb_sql_database.database.name
}

output "COSMOSDB_CONTAINER" {
  value = azurerm_cosmosdb_sql_container.container.name
}
