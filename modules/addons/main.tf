locals {
  dns_enabled = alltrue([
    local.argo_enabled,
    local.nginx_enabled,
    local.dns_domain_root != null,
  local.dns_domain_root != ""])
}

################################################################################
# Ingress
################################################################################

resource "kubectl_manifest" "argo-ingress" {
  count = local.dns_enabled ? 1 : 0

  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argo-ingress
  namespace: ${local.argo_namespace}
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  tls:
  - hosts:
    - ${local.argo_hostname}
    secretName: argo-tls
  ingressClassName: nginx
  rules:
  - host: ${local.argo_hostname}
    http:
        paths:
        - pathType: Prefix
          path: "/"
          backend:
            service:
              name: argo-argocd-server
              port:
                name: https
YAML

  depends_on = [
    kubernetes_namespace.argo,
    kubernetes_namespace.cert-manager
  ]
}
