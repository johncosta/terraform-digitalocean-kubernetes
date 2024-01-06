# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A DigitalOcean Kubernetes Cluster
# This is an example of how to deploy a DigitalOcean Kubernetes cluster using Terraform.
# See test/basic_cluster_creation_test.go for how to write automated tests for this code.
# ---------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Configure our DigitalOcean Connection
# ------------------------------------------------------------------------------

terraform {
  required_version = "~> v1.6.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.32.0"
    }
  }
}

variable "do_token" { type = string }

provider "digitalocean" {
  token = var.do_token
}

# ------------------------------------------------------------------------------
# Configure our Cluster using the DigitalOcean Kubernetes Terraform Module
# Provide name prefix as an empty string to avoid naming the cluster.
# This should produce an error, as the cluster name prefix is required.
# ------------------------------------------------------------------------------

module "k8s" {
  source = "../../../.."

  # cluster configuration
  cluster_name_prefix    = "no-cluster-region-error"
  cluster_region         = ""
  cluster_version_prefix = "1.28."

  # default node  pool configuration
  default_node_pool_node_count = 1
  default_node_pool_node_size  = "s-1vcpu-2gb"

  # vpc configuration
  allow_default_vpc = true
  cluster_addons    = {} # TODO: null vs empty map

  # configured providers
  providers = {
    digitalocean = digitalocean
  }
  path_to_kubeconfig = "" # TODO: null vs empty string
}
