kubectl exec -n elastic $(kubectl get pods -n elastic --no-headers -o custom-columns=":metadata.name" | grep elasticsearch-master1) -ti -- bash

bin/elasticsearch-service-tokens create elastic/kibana kibana_token
# Copy the token and put it in kibana.yml
cat /usr/share/elasticsearch/config/service_tokens | base64 -w0; echo ""
# save this in the secret-token secret


https://www.elastic.co/guide/en/elasticsearch/reference/8.0/service-accounts.html
https://www.elastic.co/guide/en/kibana/current/settings.html

https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html
