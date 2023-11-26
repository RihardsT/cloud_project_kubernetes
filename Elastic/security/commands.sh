https://www.elastic.co/guide/en/elasticsearch/reference/7.14/security-basic-setup-https.html


# Generate CA
kubectl exec -n elastic $(kubectl get pods -n elastic --no-headers -o custom-columns=":metadata.name" | grep elasticsearch) -it -- bash
./bin/elasticsearch-certutil http
# Follow the instructions
# For testing, I chose to generate single certificate, not one per node

# Get the zip
kubectl cp -n elastic $(kubectl get pods -n elastic --no-headers -o custom-columns=":metadata.name" | grep elasticsearch):/usr/share/elasticsearch/elasticsearch-ssl-http.zip ./elasticsearch-ssl-http.zip

# Base64 them to store in secrets I guess.
base64 -w0 elasticsearch-ssl-http/elasticsearch/http.p12
base64 -w0 elasticsearch-ssl-http/kibana/elasticsearch-ca.pem
base64 -w0 elasticsearch-ssl-http/ca/ca.p12 # can skip this one. Seems unused

# put those in secrets.yaml following the secrets_template.yaml
