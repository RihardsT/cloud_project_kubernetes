### Setup
https://argo-cd.readthedocs.io/en/stable/getting_started/
https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/


### CLI install
```
# Get the CLI
wget https://github.com/argoproj/argo-cd/releases/download/v2.9.0/argocd-linux-amd64
chmod +x argocd-linux-amd64 && sudo mv argocd-linux-amd64 /usr/bin/argocd
```

### ArgoCD server in Cluster
```
cd ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argo_config.yaml
kubectl apply -f ingress.yaml
kubectl rollout restart deployment argocd-server -n argocd

# Get initial password for admin
kubectl -n argocd get secrets argocd-initial-admin-secret -o jsonpath={'.data.password'} | base64 -d; echo

# Restart ArgoCD, if it still gives redirect loop
kubectl rollout restart deployment argocd-server -n argocd
```

### App stuff
```
cd ~/Code/cloud_project/cloud_project_kubernetes/ArgoCD
kubectl apply -n argocd -f application.yaml
```
