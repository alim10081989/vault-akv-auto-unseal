resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.rg_location
  name     = random_pet.rg_name.id

  tags = {
    environment = var.environment
  }
}