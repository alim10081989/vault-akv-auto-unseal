data "azurerm_client_config" "current" {}

# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location                  = azurerm_resource_group.rg.location
  name                      = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name       = azurerm_resource_group.rg.name
  dns_prefix                = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "sysnodepool"
    vm_size    = var.vm_size
    node_count = var.node_count
  }

  network_profile {
    network_plugin    = "azure" ## To use with Azure-CNI. Other option is kubenet
    load_balancer_sku = "standard"
  }
}

resource "azurerm_user_assigned_identity" "aks_workload_identity" {
  name                = var.uami_details["uami_name"]
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_federated_identity_credential" "workload_identity_credentials" {
  count               = var.oidc.enabled ? 1 : 0
  name                = var.uami_details["federated_creds_name"]
  resource_group_name = azurerm_resource_group.rg.name
  audience            = var.oidc.audience
  issuer              = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_workload_identity.id
  subject             = "system:serviceaccount:${var.oidc.kubernetes_namespace}:${var.oidc.kubernetes_serviceaccount_name}"

  depends_on = [azurerm_kubernetes_cluster.k8s, azurerm_user_assigned_identity.aks_workload_identity]
}

resource "random_id" "keyvault" {
  byte_length = 4
}

resource "azurerm_key_vault" "vault" {
  name                = "${var.environment}-vault-${random_id.keyvault.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment = true
  sku_name               = "standard"

  tags = {
    environment = var.environment
  }

  # access policy for the hashicorp vault service principal.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.aks_workload_identity.principal_id

    secret_permissions = [
      "Get",
    ]
  }

  # access policy for the user that is currently running terraform.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions    = ["Create", "Get", "List", "Delete", "Update", "GetRotationPolicy", "Purge"]
    secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  }
}


resource "azurerm_key_vault_secret" "my-secret" {
  for_each     = var.kv_secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.vault.id

  depends_on = [azurerm_key_vault.vault]
}

