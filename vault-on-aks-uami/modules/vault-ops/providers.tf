terraform {
  required_providers {
    #     vault = {
    #       source  = "hashicorp/vault"
    #       version = "~> 3.23.0"
    #     }
    #     kubernetes = {
    #       source  = "hashicorp/kubernetes"
    #       version = "~> 2.24.0"
    #     }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "vault" {
  address = "http://${data.local_file.vault_srv.content}:8200"
  token   = base64decode(data.local_file.root_token.content_base64)
}

# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
# }
