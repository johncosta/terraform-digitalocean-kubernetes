locals {
  nginx_addon = lookup(var.cluster_addons, "ingress", {
    enabled = false,
    config = {
      domain_root              = "example.com",
      domain_create            = false,
      domain_certificate_email = "name@example.com"
    }
  })
  nginx_enabled       = lookup(local.nginx_addon, "enabled", false)
  nginx_name          = lookup(local.nginx_addon, "name", "nginx")
  nginx_namespace     = lookup(local.nginx_addon, "namespace", "nginx")
  nginx_chart_version = lookup(local.nginx_addon, "chart_version", "4.9.0")
  nginx_config = lookup(local.nginx_addon, "config", {
    domain_root              = "example.com",
    domain_create            = false,
    domain_certificate_email = "name@example.com"
  })

  dns_domain_root          = lookup(local.nginx_config, "domain_root", "example.com")
  dns_domain_create        = lookup(local.nginx_config, "domain_create", false)
  domain_certificate_email = lookup(local.nginx_config, "domain_certificate_email", "name@example.com")

  ingress_public_ip_file_path = "/tmp"
  ingress_public_ip_file      = "nginx_public_ips.txt"
  full_path_to_public_ip_file = join("/", [local.ingress_public_ip_file_path, local.ingress_public_ip_file])
}

################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace" "nginx" {
  count = local.nginx_enabled ? 1 : 0

  metadata {
    name = local.nginx_namespace
  }
  depends_on = [
    kubernetes_namespace.cert-manager,
    kubernetes_namespace.argo
  ]
}

################################################################################
# Helm
################################################################################

resource "helm_release" "nginx" {
  count = local.nginx_enabled ? 1 : 0

  name       = local.nginx_name
  namespace  = local.nginx_namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = local.nginx_chart_version

  depends_on = [
    kubernetes_namespace.nginx,
  ]
}

################################################################################
# External IP
################################################################################

resource "null_resource" "get-nginx-public-ip" {
  count = local.nginx_enabled && local.dns_enabled ? 1 : 0

  triggers = { always_run = timestamp() }
  provisioner "local-exec" {
    command = "kubectl get svc nginx-ingress-nginx-controller -n nginx --output jsonpath='{.status.loadBalancer.ingress[0].ip}' > ${local.full_path_to_public_ip_file}"
  }
  depends_on = [
    helm_release.nginx,
  ]
}

data "local_file" "nginx-public-ip" {
  count = local.nginx_enabled && local.dns_enabled ? 1 : 0

  filename = local.full_path_to_public_ip_file
  depends_on = [
    null_resource.get-nginx-public-ip,
  ]
}
