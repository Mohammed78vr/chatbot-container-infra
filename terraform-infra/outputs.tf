output "frontend_vm_public_IP_address" {
  value = module.Vm.vm_public_ip_address
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "database_host" {
  value = module.db.database_host
}

output "database_name" {
  value = module.db.database_name
}

output "database_username" {
  value = module.db.database_username
}

output "cosmosdb_endpoint" {
  value = module.cosmosdb.COSMOSDB_ENDPOINT
}

output "cosmosdb_database" {
  value = module.cosmosdb.COSMOSDB_DATABASE
}

output "cosmosdb_container" {
  value = module.cosmosdb.COSMOSDB_CONTAINER
}

output "container_app_url" {
  value = module.container.CONTAINER_APP_URL
}