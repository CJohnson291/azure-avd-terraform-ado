# Vnet resource
resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

}

# Subnet resource
resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.subnet_address_prefixes

  # Lab only - production would use a NAT gateway
  default_outbound_access_enabled = true

}

# NSG resource
resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

}

# Attaches NSG to subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}


