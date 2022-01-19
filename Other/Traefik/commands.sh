# This works now. Yayay

cd ~/Code/CloudProject/cloud_project_kubernetes/Traefik
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
kubectl apply -f traefik-configmap.yml
kubectl apply -f traefik-deployment.yml
kubectl apply -f traefik-ui.yml
kubectl apply -f cheese.yml


kubectl get pods --all-namespaces
kubectl get services --namespace=kube-system


kubectl delete -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
kubectl delete -f traefik-configmap.yml
kubectl delete -f traefik-deployment.yml
kubectl delete -f traefik-ui.yml
kubectl delete -f cheese.yml
