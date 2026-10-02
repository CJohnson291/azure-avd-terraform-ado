# Azure provider source and version
terraform {
  required_version = "~>1.12.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.7"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-avd-state"
    storage_account_name = "stavdtfstatecj291"
    container_name       = "tfstate"
    key                  = "avd-personal.tfstate"
    use_azuread_auth     = true
  }
}

# Configure the Azure Provider 
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
  