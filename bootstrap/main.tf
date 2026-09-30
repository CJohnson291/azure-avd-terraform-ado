# Tags

locals {
  common_tags = {
    project    = "avd-ado"
    owner      = "cj291"
    managed_by = "Terraform"
  }
}

# Resource group for state storage
resource "azurerm_resource_group" "rg_state" {
  name     = "rg-avd-state"
  location = var.location
  tags     = local.common_tags
}


# Storage account for state storage
resource "azurerm_storage_account" "sa_state" {
  name                            = "stavdtfstate${var.sa_suffix}"
  resource_group_name             = azurerm_resource_group.rg_state.name
  location                        = azurerm_resource_group.rg_state.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = local.common_tags

  blob_properties {
    versioning_enabled = true
  }
}

# Container for state storage
resource "azurerm_storage_container" "sc_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.sa_state.id
  container_access_type = "private"
}

# Resource group for personal AVD environment
resource "azurerm_resource_group" "rg_avd_personal" {
  name     = "rg-avd-personal"
  location = var.location
  tags     = local.common_tags
}

# Resource group for remote app AVD environment
resource "azurerm_resource_group" "rg_avd_remoteapp" {
  name     = "rg-avd-remoteapp"
  location = var.location
  tags     = local.common_tags
}


# Role assignemnet for the Azure DevOps service principal to access the state storage account
resource "azurerm_role_assignment" "st_role" {
  scope                = azurerm_storage_account.sa_state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pipeline_sp_object_id
  principal_type       = "ServicePrincipal"
}

# Role assignemnet for the personal AVD environment resource group
resource "azurerm_role_assignment" "avd_p_role" {
  scope                = azurerm_resource_group.rg_avd_personal.id
  role_definition_name = "Contributor"
  principal_id         = var.pipeline_sp_object_id
  principal_type       = "ServicePrincipal"
}

# Role assignemnet for the remote app AVD environment resource group
resource "azurerm_role_assignment" "avd_r_role" {
  scope                = azurerm_resource_group.rg_avd_remoteapp.id
  role_definition_name = "Contributor"
  principal_id         = var.pipeline_sp_object_id
  principal_type       = "ServicePrincipal"
}   