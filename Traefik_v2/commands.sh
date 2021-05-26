kubectl apply -f traefik-customresources.yml
kubectl apply -f traefik-configmap.yml
kubectl apply -f traefik-deployment.yml
kubectl apply -f cheese.yml


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
