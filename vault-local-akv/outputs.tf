output "client_id" {
  description = "Object id of service principal."
  value       = azuread_service_principal.vault_learn.client_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.vault_learn.value
  sensitive   = true
}

output "key_vault_name" {
  description = "Azure Key Vault Name"
  value       = azurerm_key_vault.vault.name
}

output "vault_unseal_key_name" {
  description = "Azure Key Vault Name"
  value       = azurerm_key_vault_key.vault_unseal_key.name
}

output "vault_unseal_login" {
  description = "Vault Login Guide"
  value = <<EOF

  Steps:

    1. export VAULT_ADDR="http://127.0.0.1:8200"
    2. vault login $(echo "${data.local_file.vault_token.content_base64}" | base64 -d)
  
  EOF
}