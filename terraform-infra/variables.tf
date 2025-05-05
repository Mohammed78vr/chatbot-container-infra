variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}
#======================= variables for recourse group =======================
variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Region location"
  type        = string
}
#======================= varibales for Vnet modules =======================
variable "Vnet_Name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "Web_app_subnet_Name" {
  description = "Name of the Subnet for web appliaction"
  type        = string
}
#======================= varibales for VM modules =======================
variable "vm" {
  description = "Virtual machine (VM) Name"
  type        = string
}

variable "adminUserName" {
  description = "Username for the ssh admin key"
  type        = string
}
#======================= varibales for storage modules =======================
variable "container" {
  description = "Container name"
  type        = string
}

#======================= varibales for db modules =======================
variable "database_server_name" {
  description = "database server name"
  type        = string
}

variable "admin_db_username" {
  description = "Database server username"
  type        = string
}

variable "db_passowrd" {
  description = "database server password"
  type        = string
}

variable "database_name" {
  description = "database name"
  type        = string
}

variable "start_ip_address" {
  description = "start IP address for azure database firewall rules"
  type        = string
}

variable "end_ip_address" {
  description = "End IP address for azure database firewall"
  type        = string
}
#======================= varibales for Key vault modules =======================
variable "key_vault_name" {
  description = "The name of the key vaults"
  type        = string
}

variable "openai_key" {
  description = "OpenAI key secret"
  type        = string
}
#======================= varibales for Cosmosdb modules =======================
variable "cosmosdb_database_name" {
  description = "The name of the Cosmosdb database"
  type = string
}

variable "cosmosdb_container_name" {
  description = "The name of the Cosmosdb container"
  type = string
}
#======================= varibales for Container modules =======================
variable "container_registry_name" {
  description = "Name of hte container registry"
  type = string
}

variable "container_app_name" {
  description = "Container app name"
  type = string
}