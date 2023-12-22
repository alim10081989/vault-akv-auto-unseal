data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = var.k8s_cluster_name
  resource_group_name = var.resource_group_name
}

resource "helm_release" "vault" {
  name = "vault"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "hashicorp/vault"
  namespace  = var.vault_namespace

  values = [
    templatefile("${path.module}/templates/vault.yaml", {
      vault_tenant_id  = data.azurerm_client_config.current.tenant_id
      vault_akv_name   = var.akv_name,
      vault_unseal_key = var.akv_key_name
    })
  ]
  depends_on = [ data.azurerm_kubernetes_cluster.credentials ] 
}