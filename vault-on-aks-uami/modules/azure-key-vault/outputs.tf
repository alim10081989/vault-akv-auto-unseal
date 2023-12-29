output "key_vault_name" {
  description = "Azure Key Vault Name"
  value       = azurerm_key_vault.vault.name
}

output "vault_unseal_key_name" {
  description = "Azure Key Vault Name"
  value       = azurerm_key_vault_key.vault_unseal_key.name
}