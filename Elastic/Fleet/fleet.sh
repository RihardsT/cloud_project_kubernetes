# Via UI
Name: Fleet server
Hostname: https://mon3.rudenspavasaris.id.lv

Change host and set CA path:
https://mon1.rudenspavasaris.id.lv/app/fleet/settings/outputs/fleet-default-output
https://mon2.rudenspavasaris.id.lv

cert for HTTPS:
sudo jq '.default.Certificates[].domain.main' /acme/acme.json
sudo jq '.default.Certificates[] | select(.domain.main == "mon3.rudenspavasaris.id.lv") | .certificate' /acme/acme.json | sed 's/"//g' | base64 -d | sudo tee /certs/mon3.rudenspavasaris.id.lv.cert
sudo jq '.default.Certificates[] | select(.domain.main == "mon3.rudenspavasaris.id.lv") | .key' /acme/acme.json | sed 's/"//g' | base64 -d | sudo tee /certs/mon3.rudenspavasaris.id.lv.key


### On host itself, for testing.
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.8.1-linux-x86_64.tar.gz
tar xzvf elastic-agent-8.8.1-linux-x86_64.tar.gz
cd elastic-agent-8.8.1-linux-x86_64
sudo ./elastic-agent install --url=https://mon3.rudenspavasaris.id.lv:8220 \
  --fleet-server-es=https://mon2.rudenspavasaris.id.lv:443 \
  --fleet-server-service-token=TOKEN_HERE \
  --fleet-server-policy=fleet-server-policy \
  --fleet-server-cert=/certs/mon3.rudenspavasaris.id.lv.cert \
  --fleet-server-cert-key=/certs/mon3.rudenspavasaris.id.lv.key \
  --fleet-server-port=8220

curl -u elastic:changeme https://mon2.rudenspavasaris.id.lv/_cat/nodes

For Agent disable host network true I guess, if runner fleet server locally, not in K8s

## No UI
https://www.elastic.co/guide/en/fleet/8.8/create-a-policy-no-ui.html

curl -u elastic:changeme --request POST \
  --url https://mon1.rudenspavasaris.id.lv/api/fleet/agent_policies?sys_monitoring=true \
  --header 'content-type: application/json' \
  --header 'kbn-xsrf: true' \
  --data '{"id":"fleet-server-policy","name":"Fleet server policy","namespace":"default","monitoring_enabled":["logs","metrics"]}'

https://www.elastic.co/guide/en/fleet/current/agent-environment-variables.html#env-bootstrap-fleet-server
Fleet api:
https://www.elastic.co/guide/en/fleet/8.8/fleet-apis.html
```
curl -u elastic:changeme -X GET "https://mon1.rudenspavasaris.id.lv/api/fleet/agent_policies"
curl -u elastic:changeme -X GET "https://mon1.rudenspavasaris.id.lv/api/fleet/agent_policies/fleet-server-policy/full"
curl -u elastic:changeme -X GET "https://mon1.rudenspavasaris.id.lv/api/fleet/agent_policies/fleet-server-policy/download"

curl -u elastic:changeme -X POST "https://mon1.rudenspavasaris.id.lv/api/fleet/service_tokens" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d @policy.json

curl -u elastic:changeme -X POST "https://mon1.rudenspavasaris.id.lv/api/fleet/outputs" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "name": "default",
  "hosts" : [ "https://elasticsearch:9200" ],
  "type": "elasticsearch",
  "is_default":true,
  "is_default_monitoring":true,
  "ssl":{
    "certificate_authorities": ["/elasticsearch-ca.pem"]
  }
}'
curl -u elastic:changeme -X POST "https://mon1.rudenspavasaris.id.lv/api/fleet/service_tokens" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "name" : "Fleet server token",
  "value" : "SOME_VALUE"
}'
# Take the value it outputs as token ^^. Annoying. Can't pre-save I guess
curl -u elastic:changeme -X POST "https://mon1.rudenspavasaris.id.lv/api/fleet/fleet_server_hosts" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "host_urls" : [ "https://mon3.rudenspavasaris.id.lv" ],
  "name" : "Fleet server",
  "is_default" : true
}'
```
Add this to policy for the outputs
```
ssl.certificate_authorities: ["/elasticsearch-ca.pem"]
```
