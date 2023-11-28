# DigitalOcean Terraform Module
Terraform module which creates a DigitalOcean Kubernetes cluster.

This module is inspired by [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks)

[![DeepSource](https://app.deepsource.com/gh/johncosta/template-repository.svg/?label=active+issues&show_trend=true&token=_cRR3moYw4nG9ZTeToa9nfK3)](https://app.deepsource.com/gh/johncosta/template-repository/)
[![GitHub Super-Linter](https://github.com/johncosta/template-repository/actions/workflows/linter.yml/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Documentation

### External Documentation

* [DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)
* [Kubernetes Documentation](https://kubernetes.io/docs/home/)

### Features

* EKS Cluster
* Specified Private VPC
* Exported URNs for DigitalOcean Projects

### Using this module

```hcl
module "k8s" {
  source  = "terraform-digitialocean-kubernetes"
  version = "0.0.1"

  cluster_name_prefix          = "test-cluster"
  cluster_region               = "nyc1"
  cluster_version_prefix       = "1.28."

  default_node_pool_node_count = 1
  default_node_pool_node_size  = "s-2vcpu-2gb"
}
```
