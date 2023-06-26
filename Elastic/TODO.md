Minimal:
kubectl apply -f secrets.yml -f elasticsearch.yml -f kibana.yml

- [x] Elastic cert for Traefik? !!! Very much needed to get elasticsearch api working outside. Which is very important to get working.
  Got it working by setting insecureSkipVerify to true for Traefik globally. Would like it better for single IngressRoute instead.
- [ ] https://www.elastic.co/guide/en/fleet/current/running-on-kubernetes-managed-by-fleet.html
- [ ] Figure out why curl service_name doesn't work within Traefik container


### Get the proper certs for Elasticsearch
sudo mkdir /certs
sudo jq '.default.Certificates[] | select(.domain.main == "mon2.rudenspavasaris.id.lv") | .certificate' /acme/acme.json | sed 's/"//g' | base64 -d | sudo tee /certs/mon2.rudenspavasaris.id.lv.cert
sudo jq '.default.Certificates[] | select(.domain.main == "mon2.rudenspavasaris.id.lv") | .key' /acme/acme.json | sed 's/"//g' | base64 -d | sudo tee /certs/mon2.rudenspavasaris.id.lv.key
