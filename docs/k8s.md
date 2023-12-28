# Kubernetes

This module assists in creating a kubernetes cluster on DigitalOcean.  When choosing the cluster you will need
to specify some dimensions. The following are some considerations:

Considerations:
* Naming
* Region
* Version
* Capacity

## Naming

The name of the cluster is specified through the `cluster_name_prefix` variable and will determine the full name of the
cluster. Additionally, cluster resources, like the default worker pool, will be prefixed with the value of this
variable.

An example of a cluster with the name prefix of `test` would be:

    `test-<region>-cluster`

## Region
The region of the cluster is specified through the `cluster_region` variable.  This will determine the region of the
cluster and associated resources like the default worker pool.  Valid values for this variable can be found in the
DigitalOcean documentation[^1].

## Version
The version of the cluster is specified through the `cluster_version_prefix` variable.  This will determine the version
of the cluster and associated resources like the default worker pool.  Per DigitalOcean[^2], new cluster versions are
generally available within a month of the upstream release.

## Capacity

The capacity of the cluster is specified through the `default_node_pool_node_count` and
`default_node_pool_node_size` variables. These variables will determine the number of nodes and the size of the nodes.

Currently, only fixed size, default node pools are supported.  The size of the nodes is specified through the
`default_node_pool_node_size` variable. Valid values for this variable can be found in the DigitalOcean documentation[^3].

[^1]: <https://docs.digitalocean.com/products/platform/availability-matrix/>
[^2]: <https://docs.digitalocean.com/products/kubernetes/details/supported-releases/>
[^3]: <https://slugs.do-api.dev/>
