variable "environment" {
  default = "learn"
}

variable "location" {
  description = "Azure location where the resource need to be created"
  default     = "eastus"
}

variable "uami_map" {
  type = map(string)
  default = {
    "control_plane" = "UAMI_CP_LEARN_EUS"
    "kubelet"       = "UAMI_RT_LEARN_EUS"
  }
}

variable "helm_vault_ns" {
  description = "Kubernetes namespace for vault chart deployment"
  default     = "vault"
}