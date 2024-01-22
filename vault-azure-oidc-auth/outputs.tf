output "aks_cluster" {
  value = {
    name            = azurerm_kubernetes_cluster.k8s.name
    oidc_issuer_url = var.oidc_issuer_enabled ? azurerm_kubernetes_cluster.k8s.oidc_issuer_url : null
  }
  description = <<EOT
    AKS cluster details:
    * `name` - cluster name
    * `oidc_issuer_url` - cluster OIDC issuer url
  EOT
}


output "aks_workload_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_workload_identity.client_id
}

output "keyvault_uri" {
  value = azurerm_key_vault.vault.vault_uri
}