kubectl apply -f traefik.yml
kubectl apply -f services.yml
kubectl apply -f deployments.yml
# kubectl port-forward --address 0.0.0.0 service/traefik 8000:8000 8080:8080 443:4443 -n default
kubectl apply -f routers.yml
