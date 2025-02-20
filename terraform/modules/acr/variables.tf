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

variable "acr_pullers" {
    description = "The list of object ids that can pull from the ACR"
    type = map(string)
}