# Set namespace to use by default
kubectl config set-context --current --namespace=elastic
# Set back to default later
kubectl config set-context --current --namespace=default

# Define contexts
kubectl config set-context elastic --user=kubernetes-admin --cluster=kubernetes --namespace=elastic
kubectl config use-context elastic


kubectl config set-context default --user=kubernetes-admin --cluster=kubernetes --namespace=default
kubectl config use-context default
