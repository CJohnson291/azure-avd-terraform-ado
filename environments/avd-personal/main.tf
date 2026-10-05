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
