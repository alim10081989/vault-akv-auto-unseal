output "vault_ui" {
  description = "vault UI output"
  value       = data.local_file.vault_srv.content
}

output "vault_root_token" {
  description = "vault root token"
  value       = data.local_file.root_token.content
}