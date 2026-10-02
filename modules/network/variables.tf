variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resources"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "address_space" {
  type        = list(string)
  description = "The address space for the virtual network"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet"
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "The address prefixes for the subnet"
}

variable "nsg_name" {
  type        = string
  description = "The name of the network security group"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources"
}

