kubectl delete -f ./Elastic
kubectl delete -f ./Keycloak
kubectl delete -f ./Netdata
kubectl delete -f ./Nextcloud
kubectl delete -f ./Traefik
kubectl delete deployments. blog
kubectl delete service blog

kubectl delete -f ./Minecraft

# Just scale down
kubectl scale deployment collabora --replicas=0
kubectl scale deployment nextcloud --replicas=0
