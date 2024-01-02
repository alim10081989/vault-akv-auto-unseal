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
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.23.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
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