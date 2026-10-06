data "azurerm_resource_group" "rg" {
  name = "rg-avd-personal"
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
  vnet_name               = "vnet-avd-personal"
  address_space           = ["10.10.0.0/16"]
  subnet_name             = "snet-avd-personal-hosts"
  subnet_address_prefixes = ["10.10.1.0/24"]
  nsg_name                = "nsg-avd-personal"
  tags                    = local.common_tags
}

module "avd_core" {
  source                           = "../../modules/avd-core"
  resource_group_name              = data.azurerm_resource_group.rg.name
  location                         = data.azurerm_resource_group.rg.location
  host_pool_name                   = "hp-avd-personal"
  host_pool_type                   = "Personal"
  load_balancer_type               = "Persistent"
  preferred_app_group_type         = "Desktop"
  personal_desktop_assignment_type = "Automatic"
  app_group_name                   = "ag-avd-personal-desktop"
  app_group_type                   = "Desktop"
  workspace_name                   = "ws-avd-personal"
  tags                             = local.common_tags
}

module "session_hosts" {
  source              = "../../modules/session-hosts"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
  host_pool_id        = module.avd_core.host_pool_id
  host_pool_name      = module.avd_core.host_pool_name
  vm_name             = "vm-avdp-01"
  vm_size             = "Standard_B2s_v2"
  image_sku           = "Win11-25h2-ent"
  admin_username      = "avdlocaladmin"
  tags                = local.common_tags
}