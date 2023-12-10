terraform {
  required_version = "~> v1.6.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.32.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
  }
}

provider "kubernetes" {
  alias       = "default"
  config_path = local_sensitive_file.kubeconfig[0].filename
}

provider "helm" {
  alias = "default"
  kubernetes {
    config_path = local_sensitive_file.kubeconfig[0].filename
  }
}

provider "null" {
  alias = "default"
}
