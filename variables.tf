variable "cluster_name_prefix" {
  type        = string
  description = "k8s cluster name"
  nullable    = false
  default     = ""
  validation {
    condition     = var.cluster_name_prefix != null && length(var.cluster_name_prefix) != 0
    error_message = "cluster_name_prefix must be set to a non-empty string"
  }
}

variable "cluster_region" {
  type        = string
  description = "k8s cluster region"
  nullable    = false
  validation {
    condition     = var.cluster_region != null && length(var.cluster_region) != 0
    error_message = "cluster_region must be set to a non-empty string"
  }
}

variable "cluster_version_prefix" {
  type        = string
  description = "k8s version prefix"
  nullable    = false
  validation {
    condition     = var.cluster_version_prefix != null && length(var.cluster_version_prefix) != 0
    error_message = "cluster_version_prefix must be set to a non-empty string"
  }
}

variable "cluster_ipv4_cidr" {
  type        = string
  description = "k8s cluster ipv4 cidr"
  nullable    = true
  default     = null
}

variable "allow_create_vpc" {
  type        = bool
  description = "used to explicitly allow vpc creation"
  nullable    = true
  default     = true
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
  default     = "s-1vcpu-2gb"
}

variable "default_node_pool_node_count" {
  type        = number
  description = "default node pool node count"
  nullable    = false
  default     = 1
}

variable "path_to_kubeconfig" {
  type        = string
  description = "path to kubeconfig"
  nullable    = false
  default     = ""
}

variable "use_cluster_name_in_config" {
  type        = bool
  description = "use cluster name in config"
  nullable    = true
  default     = false
}

variable "cluster_addons" {
  type        = any
  description = "List of addons to enable"
  default     = null
}
