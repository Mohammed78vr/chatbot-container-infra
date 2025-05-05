subscription_id     = "<YOUR_SUBSCRIPTION_ID>" #use your subsctiption Id
resource_group_name = "stage10-terraform"
location            = "norwayeast"
#======================= varibales for Vnet modules =======================
Vnet_Name                       = "WebVnet"
Web_app_subnet_Name             = "WebAppSubnet"
#======================= varibales for VM modules =======================
vm            = "frontend-vm"
adminUserName = "azureuser"
#======================= varibales for storage modules =======================
container                  = "chat-history"
#======================= varibales for db modules =======================
database_server_name = "postgresqldbdd"
database_name        = "chatbotdb"
admin_db_username    = "azureadmin"
db_passowrd          = "Weclouddata1"
start_ip_address     = "0.0.0.0"
end_ip_address       = "0.0.0.0"
#======================= varibales for Key vaults modules =======================
key_vault_name = "key-sda"
openai_key     = "<YOUR_OPENAI_KEY>"
#======================= varibales for Cosmosdb modules =======================
cosmosdb_database_name = "chathistory"
cosmosdb_container_name = "chats"
#======================= varibales for Cosmosdb modules =======================
container_registry_name = "terraformregistr323"
container_app_name = "backend-container-3223"