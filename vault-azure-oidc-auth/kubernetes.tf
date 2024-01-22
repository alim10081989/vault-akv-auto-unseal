resource "kubernetes_service_account" "azure_workload_account" {
  for_each = var.k8s_svc_accounts
  metadata {
    name      = each.value
    namespace = each.key
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.aks_workload_identity.client_id
    }
  }
}

resource "kubernetes_pod" "kv-pod-test" {
  for_each = var.k8s_svc_accounts
  metadata {
    name      = "quick-start"
    namespace = each.key
    labels = {
      "azure.workload.identity/use" = var.oidc_issuer_enabled ? "true" : "false"
    }
  }

  spec {
    service_account_name = each.value
    container {
      image = "ghcr.io/azure/azure-workload-identity/msal-go"
      name  = "oidc"

      env {
        name  = "KEYVAULT_URL"
        value = azurerm_key_vault.vault.vault_uri
      }
      env {
        name  = "SECRET_NAME"
        value = azurerm_key_vault_secret.my-secret["my-secret"].name
      }

    }
    node_selector = {
      "kubernetes.io/os" = "linux"
    }
  }
}