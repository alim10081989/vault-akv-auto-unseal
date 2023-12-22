output "resource_group_name" {
  description = "Resource Group Name"
  value       = module.vault_rg.rg_name
}

output "key_vault_name" {
  description = "Azure Key Vault Name"
  value       = module.vault_akv.key_vault_name
}

output "vault_unseal_key_name" {
  description = "Azure Key Vault Name"
  value       = module.vault_akv.vault_unseal_key_name
}

output "kubernetes_cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.vault_aks.kubernetes_cluster_name
}