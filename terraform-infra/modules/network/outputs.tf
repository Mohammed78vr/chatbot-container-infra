output "web_app_subnet_id" {
  value = azurerm_subnet.WebSubnet.id
}

output "Vnet_name" {
  value = azurerm_virtual_network.MyVnet.name
}