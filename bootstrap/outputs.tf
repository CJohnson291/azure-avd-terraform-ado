output "state_container_name" {
  value       = azurerm_storage_container.sc_state.name
  description = "The name of the storage container used for state storage."
}

output "personal_rg_name" {
  value       = azurerm_resource_group.rg_avd_personal.name
  description = "The name of the resource group for the personal AVD environment."
}

output "remoteapp_rg_name" {
  value       = azurerm_resource_group.rg_avd_remoteapp.name
  description = "The name of the resource group for the remote app AVD environment."
}

output "state_storage_account_name" {
  value       = azurerm_storage_account.sa_state.name
  description = "The name of the storage account used for state storage."
}

output "state_rg_name" {
  value       = azurerm_resource_group.rg_state.name
  description = "The name of the resource group used for state storage."
}
