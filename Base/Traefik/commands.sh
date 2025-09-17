https://github.com/traefik/traefik/tree/master/docs/content/reference/dynamic-configuration
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.3.4/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.3.4/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
kubectl apply -f ~/Code/cloud_project/cloud_project_kubernetes/Base/Traefik_v2/

# Dashboard
https://traefik.rudenspavasaris.id.lv/dashboard/

# Further use IngressRoute like so:
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: ingressroutetls
spec:
  entryPoints:
    - https
  routes:
  - match: Host(`rudenspavasaris.id.lv`)
    kind: Rule
    services:
    - name: stilton
      port: 80
  tls:
    certResolver: default



https://observatory.mozilla.org/analyze/vieta.rudenspavasaris.id.lv

# For HTTP3? https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size
sysctl -w net.core.rmem_max=2500000



### Install Traefik 3 with Helm
helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik traefik/traefik -f helm-values.yaml --wait

# Upgrade
# https://github.com/traefik/traefik-helm-chart/tree/master?tab=readme-ov-file#upgrading
helm upgrade traefik traefik/traefik -f helm-values.yaml
# To make sure new config is loaded, delete the old pod
kubectl delete pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep traefik)

# TODO
Get Traefik working with port 80 and 443
