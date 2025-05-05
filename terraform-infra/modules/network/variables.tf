variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Region location"
  type        = string
}

variable "Vnet_Name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "Web_app_subnet_Name" {
  description = "Name of the Subnet"
  type        = string
}

variable "vm" {
  description = "Virtual machine (VM) Name"
  type        = string
}
