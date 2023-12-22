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

variable "resource_group_id" {
  type    = string
  default = ""
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_DS2_v2"
}

variable "uami_kubelet_client_id" {
  type = string
}

variable "uami_control_plane_id" {
  type = string
}

variable "uami_kubelet_principal_id" {
  type = string
}

variable "uami_kubelet_id" {
  type = string
}