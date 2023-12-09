output "cluster_name" {
  value = digitalocean_kubernetes_cluster.cluster.name
}

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.cluster.id
}

output "cluster_urn" {
  value = digitalocean_kubernetes_cluster.cluster.urn
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.cluster.endpoint
}

output "cluster_kube_config" {
  value = digitalocean_kubernetes_cluster.cluster.kube_config
}

output "full_path_to_kubeconfig" {
  value = local.full_path_to_kubeconfig
}

output "environment_variable_kubeconfig" {
  value = "export KUBECONFIG=${local.full_path_to_kubeconfig}"
}
