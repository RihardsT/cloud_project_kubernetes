
# Install
sudo curl -fL https://app.getambassador.io/download/tel2/linux/amd64/latest/telepresence -o /usr/local/bin/telepresence
sudo chmod a+x /usr/local/bin/telepresence

## Test
kubectl create deploy hello --image=k8s.gcr.io/echoserver:1.4
