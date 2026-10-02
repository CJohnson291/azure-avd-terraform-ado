output "subnet_id" {
  value       = azurerm_subnet.subnet1.id
  description = "The ID of the subnet"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet1.id
  description = "The ID of the virtual network"
}

output "network_security_group_id" {
  value       = azurerm_network_security_group.nsg1.id
  description = "The ID of the network security group"
}