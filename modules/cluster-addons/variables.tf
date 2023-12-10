variable "full_path_to_kubeconfig" {
  type        = string
  description = "Full path to the kubeconfig file"
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
        enabled = false
        chart_version = "1.0.0"
      }
    }
    EOT
  nullable    = false
  default     = {}
}

variable "cluster_id" {
  type        = string
  description = "The cluster ID"
  nullable    = false
}
