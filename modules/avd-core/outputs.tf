output "host_pool_id" {
  value       = azurerm_virtual_desktop_host_pool.hp.id
  description = "Host pool ID"
}

output "host_pool_name" {
  value       = azurerm_virtual_desktop_host_pool.hp.name
  description = "Host pool name"
}

output "application_group_id" {
  value       = azurerm_virtual_desktop_application_group.ag.id
  description = "Application group ID"
}

output "workspace_id" {
  value       = azurerm_virtual_desktop_workspace.ws.id
  description = "Workspace ID"
}

