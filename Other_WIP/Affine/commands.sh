#### About
https://docs.affine.pro/docs/self-host-affine

Basically took docker-compose file and moved it out to deployments
https://github.com/toeverything/AFFiNE/blob/canary/.github/deployment/self-host/compose.yaml


##### Init
kubectl create secret generic affine-password --from-literal=password=$(cat Secrets/password)
k apply -f ingress.yaml -f postgres.yaml -f redis.yaml -f affine.yaml

k delete -f ingress.yaml -f postgres.yaml -f redis.yaml -f affine.yaml
