# ArgoCD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

## Retrieve the ArgoCD password

Once the cluster is up and running and if ArgoCD is enabled, you can retrieve the password for the initial admin user
with the following command:

```bash
kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
