resource "azurerm_resource_group" "infra_RG" {
  name     = var.resource_group_name
  location = var.location
}

module "Vnet" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.infra_RG.name
  location            = var.location
  Vnet_Name           = var.Vnet_Name
  Web_app_subnet_Name = var.Web_app_subnet_Name
  vm                  = var.vm
  depends_on          = [azurerm_resource_group.infra_RG]
}

module "Vm" {
  source              = "./modules/vm"
  resource_group_name = azurerm_resource_group.infra_RG.name
  location            = var.location
  web_app_subnet_id   = module.Vnet.web_app_subnet_id
  vm                  = var.vm
  adminUserName       = var.adminUserName
  depends_on = [azurerm_resource_group.infra_RG,
  module.Vnet]
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.infra_RG.name
  location            = var.location
  container           = var.container
  depends_on          = [azurerm_resource_group.infra_RG]
}

module "db" {
  source               = "./modules/database"
  resource_group_name  = azurerm_resource_group.infra_RG.name
  location             = var.location
  database_server_name = var.database_server_name
  admin_db_username    = var.admin_db_username
  db_passowrd          = var.db_passowrd
  database_name        = var.database_name
  start_ip_address     = var.start_ip_address
  end_ip_address       = var.end_ip_address
  depends_on           = [azurerm_resource_group.infra_RG]
}

module "cosmosdb" {
  source                  = "./modules/cosmosdb"
  resource_group_name     = azurerm_resource_group.infra_RG.name
  location                = azurerm_resource_group.infra_RG.location
  cosmosdb_database_name  = var.cosmosdb_database_name
  cosmosdb_container_name = var.cosmosdb_container_name
  depends_on              = [azurerm_resource_group.infra_RG]
}

module "container" {
  source                  = "./modules/container"
  resource_group_name     = azurerm_resource_group.infra_RG.name
  location                = azurerm_resource_group.infra_RG.location
  container_registry_name = var.container_registry_name
  container_app_name      = var.container_app_name
  depends_on              = [azurerm_resource_group.infra_RG]
}

module "key_vault" {
  source               = "./modules/key-vault"
  resource_group_name  = azurerm_resource_group.infra_RG.name
  location             = var.location
  key_vault_name       = var.key_vault_name
  manged_identity_id   = module.Vm.vm_identity
  database_host        = module.db.database_host
  database_name        = var.database_name
  admin_db_username    = var.admin_db_username
  db_passowrd          = var.db_passowrd
  storage_SAS          = module.storage.storage_SAS
  container_name       = var.container
  vm_public_ip_address = module.Vm.vm_public_ip_address
  OpenAi_key           = var.openai_key

  cosmosdb_endpoint  = module.cosmosdb.COSMOSDB_ENDPOINT
  cosmosdb_key       = module.cosmosdb.COSMOSDB_KEY
  cosmosdb_database  = module.cosmosdb.COSMOSDB_DATABASE
  cosmosdb_container = module.cosmosdb.COSMOSDB_CONTAINER

  container_app_url      = module.container.CONTAINER_APP_URL
  container_app_identity = module.container.container_app_identity
  depends_on             = [azurerm_resource_group.infra_RG, module.Vm, module.db, module.storage, module.cosmosdb, module.container]
}
