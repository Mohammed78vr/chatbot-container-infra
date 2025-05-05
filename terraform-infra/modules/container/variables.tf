variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Region location"
  type        = string
}

variable "container_registry_name" {
  description = "Name of hte container registry"
  type = string
}

variable "container_app_name" {
  description = "Container app name"
  type = string
}