variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Region location"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the key vaults"
  type        = string
}

variable "manged_identity_id" {
  description = "Managed Identity id from the vm"
  type        = string
}

variable "database_host" {
  description = "Database host"
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

variable "storage_SAS" {
  description = "Shared access signiture url"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "vm_public_ip_address" {
  description = "The public IP address for the VM"
  type        = string
}

variable "OpenAi_key" {
  description = "OpenAI key secret"
  type        = string
}

variable "cosmosdb_endpoint" {
  description = "CosmosDB Endpoint"
  type        = string
}

variable "cosmosdb_key" {
  description = "CosmosDB key"
  type        = string
}

variable "cosmosdb_database" {
  description = "CosmosDB database name"
  type        = string
}

variable "cosmosdb_container" {
  description = "CosmosDB container name"
  type        = string
}

variable "container_app_url" {
  description = "Container app name"
  type = string
}

variable "container_app_identity" {
  description = "Manged Identity for the container app"
  type = string
}