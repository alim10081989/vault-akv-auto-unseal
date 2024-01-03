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

resource "null_resource" "k8s_config" {
  provisioner "local-exec" {
    when    = create
    command = <<EOL
    sleep 180
    kubectl get svc vault-ui -n vault --output jsonpath='{.status.loadBalancer.ingress[0].ip}' > ${path.cwd}/files/vault_ui
    kubectl exec vault-0 -n vault -- vault operator init > ${path.cwd}/files/vault_init_output
    grep -i root ${path.cwd}/files/vault_init_output | awk '{print $NF}' | tr -d "\n" > ${path.cwd}/files/vault_root_token
    kubectl exec vault-0 -n vault -- cat /var/run/secrets/kubernetes.io/serviceaccount/token >  ${path.cwd}/files/k8s_service_account_token
    EOL
    environment = {
      KUBECONFIG = "${path.cwd}/files/kubeconfig"
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOL
    > ${path.cwd}/files/vault_ui
    > ${path.cwd}/files/vault_init_output
    > ${path.cwd}/files/vault_root_token
    > ${path.cwd}/files/k8s_service_account_token
    EOL
  }

  depends_on = [
    kubernetes_namespace.vault,
    helm_release.vault
  ]
}
