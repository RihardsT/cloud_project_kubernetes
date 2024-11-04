### Install
https://github.com/nextcloud/all-in-one/tree/main/nextcloud-aio-helm-chart/

```
kubectl create secret generic nextcloud-password --from-literal=db_password=$(cat Secrets/db_password) --from-literal=nc_admin_password=$(cat Secrets/nc_admin_password)

wget https://raw.githubusercontent.com/nextcloud/all-in-one/main/nextcloud-aio-helm-chart/values.yaml
# Update the values file

helm repo add nextcloud-aio https://nextcloud.github.io/all-in-one/

helm repo update
helm install nextcloud-aio nextcloud-aio/nextcloud-aio-helm-chart -f values.yaml
k patch  service nextcloud-aio-apache -p '{"spec":{"type":"ClusterIP"}}' # Change LoadBalancer to ClusterIP
k apply -f ingress.yaml
# kubectl rollout restart $(k get deployment -o NAME | grep nextcloud-aio)
```

### Upgrade
Haven't tried yet
```
# Stop pods
# Upgrade helm chart and values file
# Install again
```

sudo -u www-data php occ user:resetpassword admin
sudo -u www-data php occ user:add --display-name "Rihards" -g "admin" --email rudenspavasaris@proton.me rihards


https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md#6-how-to-debug-things
https://docs.nextcloud.com/server/latest/admin_manual/

### Uninstall
```
helm uninstall nextcloud-aio
```
