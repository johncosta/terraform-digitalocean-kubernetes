locals {
  argo_addon = lookup(var.cluster_addons, "argo", {
    enabled = false,
    config  = {}
  })
  argo_enabled       = lookup(local.argo_addon, "enabled", false)
  argo_name          = lookup(local.argo_addon, "name", "argo")
  argo_namespace     = lookup(local.argo_addon, "namespace", "argo")
  argo_chart_config  = lookup(local.argo_addon, "chart_config", {})
  argo_chart_version = lookup(local.argo_addon, "chart_version", "5.51.6")
  argo_record_name   = lookup(local.argo_addon, "record_name", "argo")
  #  argo_module_config = lookup(local.argo_addon, "config", {
  #    subdomain_create = false
  #  })
  //argo_subdomain_create = lookup(local.argo_module_config, "subdomain_create", false)

  argo_hostname = join(".", [local.argo_record_name, local.dns_domain_root])
}

################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace" "argo" {
  count = local.argo_enabled ? 1 : 0

  metadata {
    name = local.argo_namespace
  }

  depends_on = [
    kubernetes_namespace.cert-manager,
  ]
}

################################################################################
# Helm
################################################################################

resource "helm_release" "argo" {
  count = local.argo_enabled ? 1 : 0

  name       = local.argo_name
  namespace  = local.argo_namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = local.argo_chart_version

  dynamic "set" {
    for_each = local.argo_chart_config

    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    kubernetes_namespace.argo,
  ]
}
