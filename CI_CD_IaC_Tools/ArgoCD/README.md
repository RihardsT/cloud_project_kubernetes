### Setup
https://argo-cd.readthedocs.io/en/stable/getting_started/
https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/


### CLI install
```shell
# Get the CLI
wget https://github.com/argoproj/argo-cd/releases/download/v2.9.0/argocd-linux-amd64
chmod +x argocd-linux-amd64 && sudo mv argocd-linux-amd64 /usr/bin/argocd
```

### ArgoCD server in Cluster
```shell
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
```shell
cd ~/Code/cloud_project/cloud_project_kubernetes/ArgoCD
kubectl apply -n argocd -f application.yaml
```

### Application set
```shell
kubectl apply -n argocd -f ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/ArgoCD/application_set.yaml
```

### Apps with Helm
Currently this one seems to be the best.
Just one helm apply to get all the apps it seems.
That is, if the ArgoCD applications fit into the same template,
but I guess they pretty much should.
```shell
helm upgrade --install apps ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/ArgoCD/Apps/ -f ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/ArgoCD/Apps/versions.yaml
helm uninstall apps
```
