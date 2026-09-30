# Azure provider source and version
terraform {
  required_version = "~>1.12.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.7"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

