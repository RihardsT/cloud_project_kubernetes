### About
Chart repo  
https://github.com/actions/actions-runner-controller

### Further on setting it up with ArgoCD
```
kubectl apply -f ~/Code/cloud_project/cloud_project_kubernetes/CI_CD_IaC_Tools/GithubActionsRunner/
```

### Install with helm manually
```
NAMESPACE="github-arc"
helm install github-arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```

```
INSTALLATION_NAME="github-arc-runners"
NAMESPACE="github-arc"
GITHUB_CONFIG_URL="REPO"
GITHUB_PAT="TOKEN"
helm install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_PAT}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```
