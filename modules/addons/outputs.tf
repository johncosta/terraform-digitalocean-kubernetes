output "addon_output_argo_config" {
  value = local.argo_addon
}

output "nginx_public_ip" {
  value = try(data.local_file.nginx-public-ip[0].content, "")
}

output "addon_output_cluster_name" {
  value = var.cluster_name
}

output "addon_output_cluster_id" {
  value = var.cluster_id
}
