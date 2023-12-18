data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "msgraphid" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.msgraphid.result.MicrosoftGraph
}

data "local_file" "vault_token" {
  filename = "${path.module}/root_token"
}