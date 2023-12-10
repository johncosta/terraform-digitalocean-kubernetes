output "cluster_name" {
  value = digitalocean_kubernetes_cluster.this.name
}

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.this.id
}

output "cluster_urn" {
  value = digitalocean_kubernetes_cluster.this.urn
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.this.endpoint
}

output "cluster_kube_config" {
  value = digitalocean_kubernetes_cluster.this.kube_config
}

output "full_path_to_kubeconfig" {
  value = local.full_path_to_kubeconfig
}

output "environment_variable_kubeconfig" {
  value = "export KUBECONFIG=${local.full_path_to_kubeconfig}"
}

output "cluster_addons" {
  value = var.cluster_addons
}
