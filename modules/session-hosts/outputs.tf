output "vm_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "ID of the VM"
}

output "vm_name" {
  value       = azurerm_windows_virtual_machine.vm.name
  description = "Name of the VM"
}