variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Region location"
  type        = string
}

variable "cosmosdb_database_name" {
  description = "The name of the Cosmosdb database"
  type = string
}

variable "cosmosdb_container_name" {
  description = "The name of the Cosmosdb container"
  type = string
}