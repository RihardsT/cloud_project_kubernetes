### About
Even though the chart is deprecated in favor of ECK, trying it anyway.

# Prep
```
helm repo add elastic https://helm.elastic.co
helm repo update
```
### Install
```
helm install --namespace elastic apm-server -f values.yaml elastic/apm-server

helm upgrade --namespace elastic apm-server -f values.yaml elastic/apm-server
```

### Remove
```
helm uninstall --namespace elastic apm-server
```
