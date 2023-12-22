module "vault_rg" {
  source      = "./modules/azure-resource-group"
  rg_location = var.location
}

module "vault_uami" {
  source = "./modules/azure-uami"

  resource_group_name     = module.vault_rg.rg_name
  resource_group_location = module.vault_rg.rg_location
  resource_group_id         = module.vault_rg.rg_id
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
  count = 1

  resource_group_name       = module.vault_rg.rg_name
  resource_group_location   = module.vault_rg.rg_location
  resource_group_id         = module.vault_rg.rg_id
  uami_control_plane_id     = module.vault_uami.uami_cp_id
  uami_kubelet_client_id    = module.vault_uami.uami_rt_client_id
  uami_kubelet_principal_id = module.vault_uami.uami_rt_principal_id
  uami_kubelet_id           = module.vault_uami.uami_rt_id

  depends_on = [ module.vault_uami ]

}