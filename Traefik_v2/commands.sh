kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
kubectl apply -f ~/Code/cloud_project/cloud_project_kubernetes/Traefik_v2/

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
