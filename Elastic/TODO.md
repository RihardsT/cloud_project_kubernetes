Minimal:
kubectl apply -f secrets.yml -f elasticsearch.yml -f kibana.yml

- [ ] https://www.elastic.co/guide/en/fleet/current/running-on-kubernetes-managed-by-fleet.html
- [ ] Elastic cert for Traefik?
- [ ] Figure out why curl service_name doesn't work within Traefik container
