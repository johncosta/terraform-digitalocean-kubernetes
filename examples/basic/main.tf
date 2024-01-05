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
# ------------------------------------------------------------------------------

module "k8s" {
  source = "../../"
  providers = {
    digitalocean = digitalocean
  }

  # cluster configuration
  cluster_name_prefix    = "basic-cluster-unit-test"
  cluster_region         = "nyc1"
  cluster_version_prefix = "1.28."

  # vpc configuration
  cluster_ipv4_cidr = "10.250.1.0/24"
}

output "cluster_name" {
  value = module.k8s.cluster_name
}

output "vpc_configured_as" {
  value = module.k8s.local_vpc_configured_as
}
