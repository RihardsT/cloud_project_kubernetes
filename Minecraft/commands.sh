kubectl exec -ti minecraft- bash
rcon-cli /whitelist add USERNAME

# Minecraft is not accessible from the get go, if the image is not pulled beforehand.
# Container restart required to get it to work in that case. Feels like a Kubernetes bug, but I hadn't updated to latest version then.
# Minecraft will time out until restarted
kubectl scale deployment minecraft --replicas=0
kubectl scale deployment minecraft --replicas=1

kubectl logs --follow $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep minecraft)

# And this is no longer necessary, as I set Ansible to pull the image before applying this
