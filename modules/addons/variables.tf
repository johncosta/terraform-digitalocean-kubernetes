variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "cluster_id" {
  type        = string
  description = "Id of the cluster"
}

variable "cluster_addons" {
  type        = map(any)
  description = "List of addons to enable"
  default     = {}
}
