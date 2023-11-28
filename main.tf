locals {
  worker_pool_name = join("-", [var.cluster_name_prefix, "default-worker-pool"])
  cluster_name     = join("-", [var.cluster_name_prefix, "cluster"])
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
}
