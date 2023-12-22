variable "resource_group_name" {
  type        = string
  description = "Resource group under which UAMI needs to be created"
}

variable "k8s_cluster_name" {
  type        = string
  description = "Pre-configured K8s cluster name"
}

variable "vault_namespace" {
  type        = string
  description = "Namespace where vault chart need to be deployed"
}

variable "akv_name" {
  type        = string
  description = "Azure Key Vault Name"
}

variable "akv_key_name" {
  type        = string
  description = "Azure Key Vault Key Name"
}