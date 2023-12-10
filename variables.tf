variable "cluster_version_prefix" {
  type        = string
  description = "k8s version prefix"
  nullable    = false
}

variable "cluster_name_prefix" {
  type        = string
  description = "k8s cluster name"
  nullable    = false
}

variable "cluster_region" {
  type        = string
  description = "k8s cluster region"
  nullable    = false
}

variable "cluster_ipv4_cidr" {
  type        = string
  description = "k8s cluster ipv4 cidr"
  nullable    = true
  default     = null
}

variable "allow_default_vpc" {
  type        = bool
  description = "used to explicitly allow default vpc"
  nullable    = true
  default     = false
}

variable "default_node_pool_node_size" {
  type        = string
  description = "default node pool node size"
  nullable    = false
}

variable "default_node_pool_node_count" {
  type        = number
  description = "default node pool node count"
  nullable    = false
}

variable "path_to_kubeconfig" {
  type        = string
  description = "path to kubeconfig"
  nullable    = false
}

variable "use_cluster_name_in_config" {
  type        = bool
  description = "use cluster name in config"
  nullable    = true
  default     = false
}

variable "cluster_addons" {
  type = map(
    object({
      enabled       = bool
      chart_version = string
    })
  )
  description = <<EOT
    cluster_addons = {
      addon =  {
        enabled = "true"
        chart_version = "1.0.0"
      }
    }
    EOT
  nullable    = true
  default     = null
}
