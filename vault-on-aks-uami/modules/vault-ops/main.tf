data "azurerm_kubernetes_cluster" "credentials" {
  name                = var.k8s_cluster_name
  resource_group_name = var.resource_group_name
}

data "kubernetes_service" "vault_ui" {
  metadata {
    name      = "vault-ui"
    namespace = "vault"
  }
}

data "local_file" "vault_srv" {
  filename = "${path.cwd}/files/vault_ui"
}

data "local_file" "root_token" {
  filename = "${path.cwd}/files/vault_root_token"
}

data "local_file" "k8s_sa_token" {
  filename = "${path.cwd}/files/k8s_service_account_token"
}

resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "creds" {
  mount               = vault_mount.kvv2.path
  name                = "devwebapp/config"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username = "giraffe",
      password = "salsa"
    }
  )
}

data "vault_kv_secret_v2" "creds_example" {
  mount = vault_mount.kvv2.path
  name  = vault_kv_secret_v2.creds.name
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "k8s_config" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
  kubernetes_ca_cert = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  token_reviewer_jwt = data.local_file.k8s_sa_token.content
}


resource "vault_kubernetes_auth_backend_role" "k8s_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "devweb-app"
  bound_service_account_names      = ["internal-app"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.k8s_policy.name]
}

resource "vault_policy" "k8s_policy" {
  name = "devwebapp"

  policy = <<EOT
path "secret/data/devwebapp/config" {
  capabilities = ["read"]
}
EOT
}


resource "null_resource" "k8s_manifest" {
  provisioner "local-exec" {
    when    = create
    command = <<EOL
    kubectl apply -f ${path.cwd}/manifests/internal-app.yaml
    kubectl apply -f ${path.cwd}/manifests/devwebapp.yaml
    EOL
    environment = {
      KUBECONFIG = "${path.cwd}/files/kubeconfig"
    }
  }
  depends_on = [vault_kubernetes_auth_backend_role.k8s_role]
}
