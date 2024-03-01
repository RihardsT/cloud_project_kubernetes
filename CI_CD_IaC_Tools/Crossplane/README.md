### What's lacking
- Dry run option for more than 3 years now. What the hell?
  https://github.com/crossplane/crossplane/issues/1805
- Not having separate backup for Crossplane, but relying on backing up whole
  Kubernetes does not seem like a responsible design
- Not only lack of backups, but the whole plethora of API calls
  it supposedly makes, reeks irresponsible design to me.
- Just because everyone is over the moon with Kubernetes,
  should not automatically make everything running on K8s cool

- [ ] As everything is in Kubernetes, backup/restore it

### Install Crossplane
https://docs.crossplane.io/latest/software/install/

```
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane \
--namespace crossplane-system \
--create-namespace crossplane-stable/crossplane

kubectl get all -n crossplane-system
```
### Use it
#### Scaleway
https://github.com/scaleway/crossplane-provider-scaleway
https://marketplace.upbound.io/providers/scaleway/provider-scaleway/
```
cd ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/Crossplane
kubectl apply -f secrets.yaml -f scaleway_provider.yaml
kubectl apply -f scaleway_bucket.yaml
kubectl get buckets

kubectl delete -f scaleway_bucket.yaml
kubectl get buckets
```
#### Gitlab
https://marketplace.upbound.io/providers/crossplane-contrib/provider-gitlab/
```
cd ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/Crossplane
kubectl apply -f secrets.yaml -f gitlab_provider.yaml
kubectl apply -f gitlab_resources.yaml
kubectl delete -f gitlab_resources.yaml
```
