resource "azurerm_resource_group" "vault" {
  name     = "${var.environment}-vault-rg"
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "random_id" "keyvault" {
  byte_length = 4
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                = "${var.environment}-vault-${random_id.keyvault.hex}"
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment = true
  sku_name               = "standard"

  tags = {
    environment = var.environment
  }

  # access policy for the hashicorp vault service principal.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azuread_service_principal.vault_learn.object_id

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

resource "local_file" "vault_cfg" {
  content = templatefile("vault.tmpl",
    {
      vault_client_id     = azuread_service_principal.vault_learn.client_id,
      vault_client_secret = azuread_service_principal_password.vault_learn.value
      vault_tenant_id     = data.azurerm_client_config.current.tenant_id,
      akv_name            = azurerm_key_vault.vault.name,
      vault_key           = azurerm_key_vault_key.vault_unseal_key.name,
      vault_storage_path  = var.local_storage_path
    }
  )
  filename = "./vault.hcl"
}

resource "null_resource" "vault_start" {
  triggers = {
    file_changed = md5(local_file.vault_cfg.content)
  }

  provisioner "local-exec" {
    when = create
    command = <<EOL
    nohup vault server -config=./vault.hcl &> /dev/null &
    sleep 10 && vault operator init > ./recovery_keys_token
    grep -i root recovery_keys_token | awk '{print $NF}' > ./root_token
    vault status > ./unseal_status
    EOL
    environment = {
      VAULT_ADDR = "http://127.0.0.1:8200"
    }
  }

  depends_on = [local_file.vault_cfg]
}

resource "null_resource" "vault_stop" {
  provisioner "local-exec" {
    when = destroy
    command = <<EOL
      kill -9 $(pgrep -f vault)
      rm -rf recovery_keys_token unseal_status root_token ../storage
    EOL
  }
}