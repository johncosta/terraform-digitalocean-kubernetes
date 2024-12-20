# DigitalOcean Terraform Module
Terraform module which creates a DigitalOcean Kubernetes cluster using prescrive defaults.

This module is inspired by [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks)

[![DeepSource](https://app.deepsource.com/gh/johncosta/terraform-digitalocean-kubernetes.svg/?label=active+issues&show_trend=true&token=ZtqfwW9-roxIC4Aa8ZyhrmGB)](https://app.deepsource.com/gh/johncosta/terraform-digitalocean-kubernetes/)
[![GitHub Super-Linter](https://github.com/johncosta/template-repository/actions/workflows/linter.yml/badge.svg)](https://github.com/marketplace/actions/super-linter)
[![TerraformRegistry](https://img.shields.io/badge/Terraform-Registry-blue)](https://registry.terraform.io/modules/johncosta/kubernetes/digitalocean/latest)

## Documentation

### External Documentation

* [DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)
* [Kubernetes Documentation](https://kubernetes.io/docs/home/)

### Features

* EKS Cluster
* Specified Private VPC
* Exported URNs for DigitalOcean Projects
* Generated and Export for Kubeconfig file

### Using this module

```hcl
module "k8s" {
  source  = "terraform-digitalocean-kubernetes"
  version = "0.1.4"

  cluster_name_prefix          = "test"
  cluster_region               = "nyc1"
  cluster_version_prefix       = "1.28."

  default_node_pool_node_count = 1
  default_node_pool_node_size  = "s-2vcpu-2gb"

  cluster_ipv4_cidr            = "10.1.0.0/20"

  # writes the kubeconfig to the local filesystem
  path_to_kubeconfig         = "/full/path/to/.kube"
  use_cluster_name_in_config = true

  cluster_addons = {
    /*
     * Add ArgoCD into its own namespace
     */
    argo = {
      enabled = true
      config = {
        subdomain_create = true
      }
    }
    /*
     * Add ingress-nginx and cert-manager into their own namespaces
     */
    ingress = {
      enabled = true
      config  = {
        domain_root              = "example.com"
        domain_certificate_email = "name@example.com"
      }
    }
  }

  # required provider configuration
  providers = {
    digitalocean = digitalocean
  }
}
```

### Retrieving ArgoCD Password
If you're using the ArgoCD addon, you can retrieve the password by running the following command:

```shell
Run the following command to retrieve the ArgoCD password:
```shell
kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Use `admin` and the password to access the ArgoCD UI.
