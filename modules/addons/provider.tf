terraform {
  required_version = "~> v1.6.0"

  required_providers {
    digitalocean = {
      source                = "digitalocean/digitalocean"
      version               = "~> 2.32.0"
      configuration_aliases = [digitalocean]
    }
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
    kubectl = {
      source                = "alekc/kubectl"
      version               = "2.0.4"
      configuration_aliases = [kubectl]
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
