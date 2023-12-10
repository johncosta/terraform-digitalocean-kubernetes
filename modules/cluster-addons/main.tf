terraform {
  required_providers {
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = "~> 2.24.0"
      configuration_aliases = [kubernetes]
    }
    helm = {
      source                = "hashicorp/helm"
      version               = "~> 2.12.1"
      configuration_aliases = [helm]
    }
    null = {
      source                = "hashicorp/null"
      version               = "~> 3.2.2"
      configuration_aliases = [null]
    }
  }
}
