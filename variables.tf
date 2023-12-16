variable "app_name" {
    description = "Service Principal Name"
    default = "vault-learn"
}

variable "key_name" {
  description = "Azure Key Vault key name"
  default     = "vault-unseal-key"
}

variable "location" {
  description = "Azure location where the Key Vault resource to be created"
  default     = "eastus"
}

variable "environment" {
  default = "learn"
}

variable "resource_group_name" {
  default = "vault-demo-azure-auth"
}

variable "local_storage_path" {
    default = "/Users/aazad/Desktop/Learn/Vault/storage"
}