variable "resource_group_name" {
  type        = string
  description = "name of the resource group"
}

variable "location" {
  type        = string
  description = "location of the resource"
}

variable "host_pool_name" {
  type        = string
  description = "name of the host pool"
}

variable "host_pool_type" {
  type        = string
  description = "host pool type: Pooled or Personal"
}

variable "load_balancer_type" {
  type        = string
  description = "LB type: Persistent or DepthFirst (pooled host pools only)"
}

variable "preferred_app_group_type" {
  type        = string
  description = "Preferred application group type for the host pool: Desktop or RailApplications"
}

variable "personal_desktop_assignment_type" {
  type        = string
  default     = null
  description = "Personal host pools only. Automatic or Direct"
}

variable "maximum_sessions_allowed" {
  type        = number
  default     = null
  description = "Pooled host pools only. Maxium concurrent sessions per session host"
}

variable "app_group_name" {
  type        = string
  description = "name of the app group"
}

variable "app_group_type" {
  type        = string
  description = "type of the app group"
}

variable "workspace_name" {
  type        = string
  description = "name of the workspace"
}

variable "tags" {
  type        = map(string)
  description = "tags applied"
}