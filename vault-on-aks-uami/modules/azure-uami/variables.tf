variable "resource_group_name" {
  type        = string
  description = "Resource group under which UAMI needs to be created"
}

variable "uami_control_plane_name" {
  type        = string
  description = "Name of aks control plane uami"
}

variable "uami_kubelet_name" {
  type        = string
  description = "Name of kubelet uami"
}

variable "resource_group_location" {
  type        = string
  description = "Resource group location"
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
}