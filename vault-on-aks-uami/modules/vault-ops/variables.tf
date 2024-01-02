variable "resource_group_name" {
  type        = string
  description = "Resource group under which UAMI needs to be created"
}

variable "k8s_cluster_name" {
  type        = string
  description = "Pre-configured K8s cluster name"
}

variable "yamls" {
  type    = list(string)
  default = ["internal-app", "devwebapp"]
}