# Prep
helm repo add gitlab https://charts.gitlab.io
helm repo update
# Install
kubectl apply -f config.yml
helm install --namespace gitlab-runner gitlab-runner -f values.yml gitlab/gitlab-runner

helm upgrade --namespace gitlab-runner gitlab-runner -f values.yml gitlab/gitlab-runner

# Remove
helm uninstall --namespace gitlab-runner gitlab-runner
kubectl delete -f config.yml


### Notes:
https://docs.gitlab.com/runner/executors/kubernetes.html#using-volumes
