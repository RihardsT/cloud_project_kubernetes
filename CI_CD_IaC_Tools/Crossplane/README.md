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
kubectl apply -f secrets.yaml -f scaleway_provider.yaml
kubectl apply -f scaleway_bucket.yaml
kubectl get buckets

kubectl delete -f scaleway_bucket.yaml
kubectl get buckets
```
#### Gitlab
https://marketplace.upbound.io/providers/crossplane-contrib/provider-gitlab/
```
kubectl apply -f secrets.yaml -f gitlab_provider.yaml
kubectl apply -f gitlab_resources.yaml
```
