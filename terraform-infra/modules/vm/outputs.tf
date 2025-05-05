output "vm_public_ip_address" {
  value = azurerm_linux_virtual_machine.frontend_vm.public_ip_address
}

output "vm_identity" {
  value = azurerm_linux_virtual_machine.frontend_vm.identity.0.principal_id
}