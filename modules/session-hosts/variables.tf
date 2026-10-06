variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the session hosts"
}

variable "host_pool_name" {
  type        = string
  description = "Name of the host pool"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM session host"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM session host"
}

variable "image_sku" {
  type        = string
  description = "VM image sku"

}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM session host"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the session host"
}

variable "host_pool_id" {
  type        = string
  description = "Host pool ID for the session host"
}