resource "azurerm_virtual_desktop_host_pool" "hp" {
  name                             = var.host_pool_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  type                             = var.host_pool_type
  load_balancer_type               = var.load_balancer_type
  preferred_app_group_type         = var.preferred_app_group_type
  personal_desktop_assignment_type = var.personal_desktop_assignment_type
  maximum_sessions_allowed         = var.maximum_sessions_allowed
  tags                             = var.tags

}

resource "azurerm_virtual_desktop_application_group" "ag" {
  name                = var.app_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = var.app_group_type
  host_pool_id        = azurerm_virtual_desktop_host_pool.hp.id
  tags                = var.tags

}

resource "azurerm_virtual_desktop_workspace" "ws" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws_ag" {
  application_group_id = azurerm_virtual_desktop_application_group.ag.id
  workspace_id         = azurerm_virtual_desktop_workspace.ws.id

}

