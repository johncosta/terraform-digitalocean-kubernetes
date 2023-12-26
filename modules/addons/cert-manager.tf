locals {
  cert_manager_addon = lookup(local.nginx_addon, "cert-manager", {
    enabled   = false,
    name      = "cert-manager",
    namespace = "cert-manager",
    chart_config = {
      installCRDs = true
    },
    chart_version = "1.5.3",
    module_config = {},
  })
  cert_manager_enabled       = lookup(local.cert_manager_addon, "enabled", false) # tflint-ignore: terraform_unused_declarations
  cert_manager_name          = lookup(local.cert_manager_addon, "name", "cert-manager")
  cert_manager_namespace     = lookup(local.cert_manager_addon, "namespace", "cert-manager")
  cert_manager_chart_config  = lookup(local.cert_manager_addon, "chart_config", { installCRDs = true })
  cert_manager_chart_version = lookup(local.cert_manager_addon, "chart_version", "1.5.3")
  cert_manager_module_config = lookup(local.cert_manager_addon, "module_config", {}) # tflint-ignore: terraform_unused_declarations
}

################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace" "cert-manager" {
  count = local.dns_enabled ? 1 : 0

  metadata {
    name = local.cert_manager_namespace
  }
}

################################################################################
# Helm
################################################################################

resource "helm_release" "cert-manager" {
  count = local.dns_enabled ? 1 : 0

  name       = local.cert_manager_name
  namespace  = local.cert_manager_namespace
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = local.cert_manager_chart_version

  dynamic "set" {
    for_each = local.cert_manager_chart_config

    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    kubernetes_namespace.cert-manager,
  ]
}

################################################################################
# Issuers
################################################################################

resource "kubectl_manifest" "letsencrypt-staging" {
  count     = local.dns_enabled ? 1 : 0
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
 name: letsencrypt-staging
 namespace: cert-manager
spec:
 acme:
   # The ACME server URL
   server: https://acme-staging-v02.api.letsencrypt.org/directory
   # Email address used for ACME registration
   email: ${local.domain_certificate_email}
   # Name of a secret used to store the ACME account private key
   privateKeySecretRef:
     name: letsencrypt-staging
   # Enable the HTTP-01 challenge provider
   solvers:
   - http01:
       ingress:
         class:  nginx
YAML
  depends_on = [
    helm_release.cert-manager,
  ]
}

resource "kubectl_manifest" "letsencrypt-prod" {
  count     = local.dns_enabled ? 1 : 0
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: ${local.domain_certificate_email}
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
  depends_on = [
    helm_release.cert-manager,
  ]
}
