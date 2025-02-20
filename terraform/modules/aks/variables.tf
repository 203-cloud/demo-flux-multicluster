variable "aks_version" {
  description = "The version of AKS to use"
  default     = "1.31"
}

variable "prefix" {
    description = "The prefix to use for all resources"
    default     = "flux"
    type = string
}

variable "resource_group_name" {
    description = "The name of the resource group"
    type = string
}

variable "location" {
    description = "The location to deploy to"
    type = string
}
