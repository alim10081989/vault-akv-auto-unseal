output "uami_cp_id" {
  description = "Control Plane UAMI name id"
  value       = azurerm_user_assigned_identity.aks.id
}

output "uami_rt_id" {
  description = "Control Plane UAMI id"
  value       = azurerm_user_assigned_identity.kubelet.id
}

output "uami_cp_client_id" {
  description = "Control Plane UAMI client id"
  value       = azurerm_user_assigned_identity.aks.client_id
}

output "uami_rt_client_id" {
  description = "Kubelet UAMI client id"
  value       = azurerm_user_assigned_identity.kubelet.client_id
}


output "uami_cp_principal_id" {
  description = "Control Plane UAMI object id"
  value       = azurerm_user_assigned_identity.aks.principal_id
}

output "uami_rt_principal_id" {
  description = "Kubelet UAMI name object id"
  value       = azurerm_user_assigned_identity.kubelet.principal_id
}