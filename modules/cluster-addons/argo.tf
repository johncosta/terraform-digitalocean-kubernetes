locals {
  argo_config        = lookup(var.cluster_addons, "argo", { enabled = false, chart_version = null })
  argo_enabled       = local.argo_config != null ? lookup(local.argo_config, "enabled", false) : false
  argo_chart_version = local.argo_config != null ? lookup(local.argo_config, "chart_version", null) : null
  namespace          = "argo"
}

resource "null_resource" "kubeconfig" {
  count = local.argo_enabled ? 1 : 0

  provisioner "local-exec" {
    command = "until [ -f ${var.full_path_to_kubeconfig} ]; do sleep 0.5; done"
  }
}

resource "null_resource" "kubectl_get_all" {
  count = local.argo_enabled ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl get all -A; while [ $? -ne 0 ]; do kubectl get all -A; done"
  }

  depends_on = [
    null_resource.kubeconfig
  ]
}

resource "kubernetes_namespace" "argo" {
  count = local.argo_enabled ? 1 : 0

  metadata {
    name = local.namespace
  }

  depends_on = [
    null_resource.kubeconfig,
    null_resource.kubectl_get_all
  ]
}

resource "helm_release" "argo" {
  count = local.argo_enabled ? 1 : 0

  name       = "argo"
  namespace  = local.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = local.argo_chart_version

  set {
    name  = "crds.install"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.argo,
    null_resource.kubeconfig,
    null_resource.kubectl_get_all
  ]
}
