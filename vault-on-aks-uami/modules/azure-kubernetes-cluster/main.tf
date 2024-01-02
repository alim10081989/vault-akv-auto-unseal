resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location             = var.resource_group_location
  name                 = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name  = var.resource_group_name
  dns_prefix           = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  azure_policy_enabled = false
  tags = {
    "environment" = var.environment
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_control_plane_id]
  }

  kubelet_identity {
    client_id                 = var.uami_kubelet_client_id
    object_id                 = var.uami_kubelet_principal_id
    user_assigned_identity_id = var.uami_kubelet_id
  }

  default_node_pool {
    name                         = "sysnodepool"
    vm_size                      = var.vm_size
    node_count                   = var.node_count
    only_critical_addons_enabled = true
  }

  network_profile {
    network_plugin    = "azure" ## To use with Azure-CNI. Other option is kubenet
    load_balancer_sku = "standard"
  }

}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = azurerm_kubernetes_cluster.k8s.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster_node_pool" "usernodepool" {
  name                  = "usernodepool"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.vm_size
  node_count            = var.node_count
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = 2
  mode                  = "User"

  tags = {
    env = var.environment
  }

  depends_on = [ azurerm_kubernetes_cluster.k8s ]
}

resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  filename   = "${path.cwd}/kubeconfig"
  content    = azurerm_kubernetes_cluster.k8s.kube_config_raw
}