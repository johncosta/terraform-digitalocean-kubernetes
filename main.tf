locals {
  worker_pool_name = join("-", [var.cluster_name_prefix, "default-worker-pool"])
  cluster_name     = join("-", [var.cluster_name_prefix, "cluster"])
  vpc_name         = join("-", [var.cluster_name_prefix, "vpc"])

  create_vpc = var.cluster_ipv4_cidr != null && var.cluster_ipv4_cidr != ""
}

data "digitalocean_kubernetes_versions" "version" {
  version_prefix = var.cluster_version_prefix
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = local.cluster_name
  region  = var.cluster_region
  version = data.digitalocean_kubernetes_versions.version.latest_version

  node_pool {
    name       = local.worker_pool_name
    size       = var.default_node_pool_node_size
    node_count = var.default_node_pool_node_count
  }

  /*
   * Conditionally set the cluster vpc if a CIDR is passed
   */
  vpc_uuid = local.create_vpc ? digitalocean_vpc.vpc.0.id : null
}

resource "digitalocean_vpc" "vpc" {
  count = local.create_vpc ? 1 : 0

  name     = local.vpc_name
  region   = var.cluster_region
  ip_range = var.cluster_ipv4_cidr
}
