### Create
cd ~/Code/CloudProject/cloud_project_kubernetes/Keycloak
kubectl apply -f secrets.yaml
kubectl apply -f postgres.yaml
kubectl apply -f keycloak.yaml


### Each secret need to be base64 encoded.
# -w 0 to encode all as single line. echo "" to ease copy/paste
echo "BASE64_ENCODED_PASSWORD_GOES_HERE" | base64 -w 0; echo ""
base64 -w 0 FILE_NAME; echo ""


# Gatekeeper
kubectl create secret generic gatekeeper-netdata --from-file=secret_gatekeeper_netdata.yaml
