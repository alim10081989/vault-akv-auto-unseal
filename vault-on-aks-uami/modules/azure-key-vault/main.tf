data "azurerm_client_config" "current" {}

resource "random_id" "keyvault" {
  byte_length = 4
}

resource "azurerm_key_vault" "vault" {
  name                = "${var.environment}-vault-${random_id.keyvault.hex}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment = true
  sku_name               = "standard"

  tags = {
    environment = var.environment
  }

  # access policy for the hashicorp vault service principal.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.kubelet_principal_id

    key_permissions = [
      "Get",
      "WrapKey",
      "UnwrapKey",
    ]
  }

  # access policy for the user that is currently running terraform.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Create", "Get", "List", "Delete", "Update", "GetRotationPolicy", "Purge"]
  }
}

resource "azurerm_key_vault_key" "vault_unseal_key" {
  name         = var.key_name
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "wrapKey",
    "unwrapKey",
  ]
}