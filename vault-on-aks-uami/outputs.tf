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

output "k8s_kube_config" {
  description = "Kubernetes Config"
  value       = module.vault_aks.kube_config
  sensitive   = true
}

output "vault_login_cmd" {
  description = "Vault Login Guide"
  value       = <<EOF

  Steps:

    1. export VAULT_ADDR="http://${module.h_vault.vault_ui}:8200"
    2. vault login "${base64decode(module.h_vault.vault_root_token)}"

  EOF
  sensitive   = true
}
