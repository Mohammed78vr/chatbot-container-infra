# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "acctest-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment
resource "azurerm_container_app_environment" "container_app_environment" {
  name                       = "manged-Environment-${var.resource_group_name}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app#identity-2
resource "azurerm_container_app" "container_app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 1.0
      memory = "2Gi"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true   # Allows external access
    target_port      = 80     # Port your app listens on
    transport        = "http" # Can be "http", "http2", or "tcp"
    traffic_weight {
      latest_revision = true
      percentage      = 100 # Sends 100% of traffic to the 
    }
  }
}
