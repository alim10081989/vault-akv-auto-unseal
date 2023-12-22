variable "resource_group_location" {
  type        = string
  description = "Resource group location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "environment" {
  type    = string
  default = "learn"
}

variable "kubelet_principal_id" {
  type    = string
  default = ""
}

variable "key_name" {
  description = "Azure Key Vault key name"
  default     = "vault-unseal-key"
}
