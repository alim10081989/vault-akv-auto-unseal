resource "azurerm_user_assigned_identity" "aks" {
  location            = var.resource_group_location
  name                = var.uami_control_plane_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "kubelet" {
  location            = var.resource_group_location
  name                = var.uami_kubelet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "uami_assign" {
  scope                = var.resource_group_id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}