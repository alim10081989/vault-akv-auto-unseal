terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "vault" {
  address = "http://${data.local_file.vault_srv.content}:8200"
  token   = base64decode(data.local_file.root_token.content_base64)
}
