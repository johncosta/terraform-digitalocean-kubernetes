output "cluster_name" {
  value = digitalocean_kubernetes_cluster.cluster.name
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.cluster.endpoint
}

output "cluster_kube_config" {
  value = digitalocean_kubernetes_cluster.cluster.kube_config
}
