variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "environment" {
  type    = string
  default = "learn"
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}