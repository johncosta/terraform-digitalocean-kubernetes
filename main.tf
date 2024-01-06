locals {

  /*
   * Set cluster resource names.
   */
  cluster_name_prefix = join("-", [var.cluster_name_prefix, var.cluster_region])
  worker_pool_name    = substr(join("-", [local.cluster_name_prefix, "default-worker-pool"]), 0, 54) # 55 char limit
  cluster_name        = join("-", [local.cluster_name_prefix, "cluster"])
  vpc_name            = join("-", [local.cluster_name_prefix, "vpc"])

  /*
   * Conditionally create a new vpc if a CIDR is passed. Otherwise, use the default vpc.
   *
   * 1) create a new vpc with the cluster_ipv4_cidr specified by the user
   *     use_specified_vpc = true
   *     allow_create_vpc  = true
   * 2) use the cluster_ipv4_cidr specified by the user
   *     use_specified_vpc = true
   *     allow_create_vpc = false  # bring your own
   * 3) allow use of the default vpc if the user explicitly sets the variable
   *     `allow_default_vpc` to true.
   *
   * cluster_ipv4_cidr     set
   * allow_create_vpc      True (default)
   * allow_default_vpc     False (default)
   *
   * cluster_ipv4_cidr     set
   * allow_create_vpc      False
   * allow_default_vpc     False (default)
   *
   * cluster_ipv4_cidr     set
   * allow_create_vpc      True (default)
   * allow_default_vpc     True
   *
   * cluster_ipv4_cidr     unset
   * allow_create_vpc      True (default)
   * allow_default_vpc     False (default)
   *
   * cluster_ipv4_cidr     unset
   * allow_create_vpc      False
   * allow_default_vpc     False (default)
   *
   * cluster_ipv4_cidr     unset
   * allow_create_vpc      True (default)
   * allow_default_vpc     True
   */
  use_specified_vpc          = var.cluster_ipv4_cidr != null && var.cluster_ipv4_cidr != ""
  allow_create_vpc           = var.allow_create_vpc ? true : false
  allow_default_vpc          = var.allow_default_vpc ? true : false
  default_vpc_value_or_error = local.use_specified_vpc || local.allow_default_vpc ? null : file("[Error] you must explicitly set the variable `allow_default_vpc` if you want the cluster to access the default vpc or set cluster_ipv4_cidr to create a vpc.")
  cluster_vpc_uuid           = local.use_specified_vpc ? digitalocean_vpc.vpc[0].id : local.default_vpc_value_or_error
  local_vpc_configured_as = {
    use_specified_vpc = local.use_specified_vpc
    allow_create_vpc  = local.allow_create_vpc
    allow_default_vpc = local.allow_default_vpc
    cluster_vpc_uuid  = local.cluster_vpc_uuid
  }
  create_kubeconfig          = var.path_to_kubeconfig != null && var.path_to_kubeconfig != ""
  use_cluster_name_in_config = var.use_cluster_name_in_config ? true : false
  kubeconfig_filename        = local.use_cluster_name_in_config ? join("-", [local.cluster_name, "config"]) : "config"
  full_path_to_kubeconfig    = join("/", [var.path_to_kubeconfig, local.kubeconfig_filename])

  cluster_addons_enabled = var.cluster_addons != null ? true : false
}

resource "digitalocean_kubernetes_cluster" "this" {
  name    = local.cluster_name
  region  = var.cluster_region
  version = data.digitalocean_kubernetes_versions.version.latest_version

  node_pool {
    name       = local.worker_pool_name
    size       = var.default_node_pool_node_size
    node_count = var.default_node_pool_node_count
  }

  /*
   * Conditionally set the cluster vpc if a CIDR is passed.
   */
  vpc_uuid = local.cluster_vpc_uuid
}

resource "digitalocean_vpc" "vpc" {
  count = local.use_specified_vpc ? 1 : 0

  name     = local.vpc_name
  region   = var.cluster_region
  ip_range = var.cluster_ipv4_cidr

  timeouts {
    delete = "10m"
  }
}

resource "local_sensitive_file" "kubeconfig" {
  count = local.create_kubeconfig ? 1 : 0

  content  = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
  filename = local.full_path_to_kubeconfig

  depends_on = [
    digitalocean_kubernetes_cluster.this
  ]
}

module "addons" {
  source = "./modules/addons"
  count  = local.cluster_addons_enabled ? 1 : 0

  /*
   * Pass the cluster name and id to the module to ensure that addons depend on the cluster.
   */
  cluster_name   = digitalocean_kubernetes_cluster.this.name
  cluster_id     = digitalocean_kubernetes_cluster.this.id
  cluster_addons = var.cluster_addons

  providers = {
    digitalocean = digitalocean
    kubernetes   = kubernetes
    kubectl      = kubectl
    helm         = helm
  }
}
