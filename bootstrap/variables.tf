variable "subscription_id" {
  description = "The subscription ID for the Azure account."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "uksouth"
}

variable "pipeline_sp_object_id" {
  description = "The object ID of the Azure DevOps service principal."
  type        = string
}

variable "sa_suffix" {
  description = "Suffix for the storage account name."
  type        = string
  default     = "cj291"
}