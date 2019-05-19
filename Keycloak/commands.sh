### Create
kubectl apply -f secrets.yml
kubectl apply -f keycloak.yml


### Each secret need to be base64 encoded.
# -w 0 to encode all as single line. echo "" to ease copy/paste
echo "BASE64_ENCODED_PASSWORD_GOES_HERE" | base64 -w 0; echo ""
base64 -w 0 FILE_NAME; echo ""
