# Prep
helm repo add gitlab https://charts.gitlab.io
helm repo update
# Install
kubectl apply -f config.yaml
helm install --namespace gitlab-runner gitlab-runner -f values.yaml gitlab/gitlab-runner

helm upgrade --namespace gitlab-runner gitlab-runner -f values.yaml gitlab/gitlab-runner

# Remove
helm uninstall --namespace gitlab-runner gitlab-runner
kubectl delete -f config.yaml


### Notes:
https://docs.gitlab.com/runner/executors/kubernetes.html#using-volumes
