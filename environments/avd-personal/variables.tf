variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "avd_users_group_object_id" {
  description = "The object ID of the AVD Users group in Entra ID"
  type        = string
}

variable "deploy_session_hosts" {
  type        = bool
  default     = false
  description = "Default is set to false, meaning only the free core resources will be deployed."
}