# Base
helm upgrade --install traefik traefik/traefik -f helm-values.yaml -f helm-values_k0s.yaml --set service.externalIPs[0]=129.151.200.81 && \
kubectl delete pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" --sort-by=.metadata.creationTimestamp | grep traefik | head -n 1)
