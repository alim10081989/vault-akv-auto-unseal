terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>1.5"
    }
  }
}

provider "azuread" {}
provider "null" {}
provider "azapi" {}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}