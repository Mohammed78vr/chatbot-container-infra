resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Creating a cosmosdb account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account#attributes-reference
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "tf-cosmos-db-${random_integer.ri.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # This is for NoSQL

  automatic_failover_enabled = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "westus"
    failover_priority = 0
  }
}

# Creatinga cosmodb database
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database
resource "azurerm_cosmosdb_sql_database" "database" {
  name                = var.cosmosdb_database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
}

# Creating a container
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container
resource "azurerm_cosmosdb_sql_container" "container" {
  name                  = var.cosmosdb_container_name
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmosdb.name
  database_name         = azurerm_cosmosdb_sql_database.database.name
  partition_key_paths   = ["/id"] # Adjust based on your data model
  partition_key_version = 2
}