resource "azuread_application" "vault_learn" {
  display_name = var.app_name
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.msgraphid.result.MicrosoftGraph
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Directory.ReadWrite.All"]
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "vault_learn" {
  client_id                    = azuread_application.vault_learn.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "vault_learn" {
  service_principal_id = azuread_service_principal.vault_learn.object_id
}

resource "null_resource" "aad_admin_consent" {
  provisioner "local-exec" {
    command = "sleep 30 && az ad app permission admin-consent --id ${azuread_application.vault_learn.client_id}"
  }
}
