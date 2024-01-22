variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "oidc_issuer_enabled" {
  type        = bool
  description = "Defines if OIDC issuer should be enabled on cluster"
  default     = true
}

variable "workload_identity_enabled" {
  type        = bool
  description = "Defines if workload identity should be enabled on cluster. This requires oidc_issuer_enabled set to true"
  default     = true
}

variable "oidc" {
  type = object({
    enabled                        = bool
    audience                       = optional(list(string), ["api://AzureADTokenExchange"])
    kubernetes_namespace           = string
    kubernetes_serviceaccount_name = string
  })
  description = "Configure OIDC federation settings to establish a trusted token mechanism between the Kubernetes cluster and external systems."
  default = {
    enabled                        = true
    kubernetes_namespace           = "default"
    kubernetes_serviceaccount_name = "workload-identity-sa"
  }
}

variable "environment" {
  type    = string
  default = "learn"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_DS2_v2"
}

variable "uami_details" {
  type        = map(string)
  description = "details of user assigned managed identity"
  default = {
    "uami_name"            = "workload-identity-uami"
    "federated_creds_name" = "workload-identity-creds"
  }
}

variable "kv_secrets" {
  type        = map(string)
  description = "Secrets to be configured in vault"
  default = {
    "my-secret" = "Hello!"
  }
}

variable "k8s_svc_accounts" {
  type        = map(string)
  description = "Service Accounts to be configured in AKS"
  default = {
    "default" = "workload-identity-sa"
  }
}

