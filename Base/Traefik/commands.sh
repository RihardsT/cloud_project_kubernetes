# TODO
- [x] Get Traefik working with port 80 and 443
  Workaround with iptables
  sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8000
  sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443
- [x] Get HTTPS working

### Install Traefik 3 with Helm
helm repo add traefik https://traefik.github.io/charts
helm repo update

# /acme folder has to be created first.
k apply -f local_pv.yaml
helm install traefik traefik/traefik -f helm-values.yaml --wait
# Upgrade
# https://github.com/traefik/traefik-helm-chart/tree/master?tab=readme-ov-file#upgrading
# To make sure new config is loaded, delete the old pod also
helm upgrade --install traefik traefik/traefik -f helm-values.yaml && \
kubectl delete pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" --sort-by=.metadata.creationTimestamp | grep traefik | head -n 1)
# kubectl delete pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep traefik)

###
helm uninstall traefik


# Check what helm would apply
helm template traefik traefik/traefik -f helm-values.yaml
