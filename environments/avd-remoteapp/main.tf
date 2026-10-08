data "azurerm_resource_group" "rg" {
  name = "rg-avd-remoteapp"
}

# Tags

locals {
  common_tags = {
    project    = "avd-ado"
    owner      = "cj291"
    managed_by = "Terraform"
  }
}

module "network" {
  source                  = "../../modules/network"
  location                = data.azurerm_resource_group.rg.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  vnet_name               = "vnet-avd-remoteapp"
  address_space           = ["10.20.0.0/16"]
  subnet_name             = "snet-avd-remoteapp-hosts"
  subnet_address_prefixes = ["10.20.1.0/24"]
  nsg_name                = "nsg-avd-remoteapp"
  tags                    = local.common_tags
}

module "avd_core" {
  source                   = "../../modules/avd-core"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  host_pool_name           = "hp-avd-remoteapp"
  host_pool_type           = "Pooled"
  load_balancer_type       = "DepthFirst"
  preferred_app_group_type = "RailApplications"
  maximum_sessions_allowed = 4
  app_group_name           = "ag-avd-remoteapp-edge"
  app_group_type           = "RemoteApp"
  workspace_name           = "ws-avd-remoteapp"
  tags                     = local.common_tags
}

resource "azurerm_virtual_desktop_application" "edge_portal" {
  name                         = "edge-portal"
  application_group_id         = module.avd_core.application_group_id
  friendly_name                = "Contractor Portal"
  path                         = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
  command_line_argument_policy = "Require"
  command_line_arguments       = "--app=https://github.com/CJohnson291/azure-avd-terraform-ado"
  show_in_portal               = true
}

resource "azurerm_role_assignment" "ag_desktop_user" {
  principal_id         = var.avd_users_group_object_id
  principal_type       = "Group"
  role_definition_name = "Desktop Virtualization User"
  scope                = module.avd_core.application_group_id
}

resource "azurerm_role_assignment" "vm_user_login" {
  principal_id         = var.avd_users_group_object_id
  principal_type       = "Group"
  role_definition_name = "Virtual Machine User Login"
  scope                = data.azurerm_resource_group.rg.id
}