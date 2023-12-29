data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = var.k8s_cluster_name
  resource_group_name = var.resource_group_name
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.vault_namespace
  }

}

resource "helm_release" "vault" {
  name = "vault"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  namespace  = kubernetes_namespace.vault.metadata[0].name

  values = [
    templatefile("${path.module}/templates/vault.yaml", {
      vault_tenant_id  = data.azurerm_client_config.current.tenant_id
      vault_akv_name   = var.akv_name,
      vault_unseal_key = var.akv_key_name
    })
  ]
  depends_on = [
    data.azurerm_kubernetes_cluster.credentials,
    kubernetes_namespace.vault
  ]
}

resource "null_resource" "vault_init" {
  provisioner "local-exec" {
    when    = create
    command = <<EOL
    kubectl exec -it vault-0 -n vault -- vault operator init > ${path.cwd}/recovery_keys_token
    grep -i root recovery_keys_token | awk '{print $NF}' > ${path.cwd}/root_token
    EOL
    environment = {
      KUBECONFIG = "${path.cwd}/kubeconfig"
    }
  }
  depends_on = [
    kubernetes_namespace.vault
  ]
}