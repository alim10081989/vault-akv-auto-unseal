module "vault_rg" {
  source      = "./modules/azure-resource-group"
  rg_location = var.location
}

module "vault_uami" {
  source = "./modules/azure-uami"

  resource_group_name     = module.vault_rg.rg_name
  resource_group_location = module.vault_rg.rg_location
  resource_group_id       = module.vault_rg.rg_id
  uami_control_plane_name = var.uami_map["control_plane"]
  uami_kubelet_name       = var.uami_map["kubelet"]
}

module "vault_akv" {
  source = "./modules/azure-key-vault"

  resource_group_name     = module.vault_rg.rg_name
  resource_group_location = module.vault_rg.rg_location
  kubelet_principal_id    = module.vault_uami.uami_rt_principal_id

}


module "vault_aks" {
  source = "./modules/azure-kubernetes-cluster"

  resource_group_name       = module.vault_rg.rg_name
  resource_group_location   = module.vault_rg.rg_location
  resource_group_id         = module.vault_rg.rg_id
  uami_control_plane_id     = module.vault_uami.uami_cp_id
  uami_kubelet_client_id    = module.vault_uami.uami_rt_client_id
  uami_kubelet_principal_id = module.vault_uami.uami_rt_principal_id
  uami_kubelet_id           = module.vault_uami.uami_rt_id

  depends_on = [
    module.vault_uami
  ]

}

module "vault_helm" {
  source = "./modules/vault-helm-chart"

  resource_group_name = module.vault_rg.rg_name
  k8s_cluster_name    = module.vault_aks.kubernetes_cluster_name
  akv_name            = module.vault_akv.key_vault_name
  vault_namespace     = var.helm_vault_ns
  akv_key_name        = module.vault_akv.vault_unseal_key_name

}


module "h_vault" {
  source = "./modules/vault-ops"

  resource_group_name = module.vault_rg.rg_name
  k8s_cluster_name    = module.vault_aks.kubernetes_cluster_name
}