### Notes
https://github.com/docker-mailserver/docker-mailserver/issues/2094


### Helm Chart, via community
https://github.com/funkypenguin/helm-docker-mailserver

```
helm repo add docker-mailserver https://docker-mailserver.github.io/docker-mailserver-helm/
helm repo update
helm install -n mailserver --create-namespace docker-mailserver docker-mailserver/docker-mailserver

helm uninstall -n mailserver docker-mailserver
```
