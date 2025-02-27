### Docs:
https://radicale.org/v3.html

### Build image
git clone https://github.com/Kozea/Radicale.git
cd Radicale
sudo nerdctl run -d --name buildkitd --privileged -v ${PWD}:/d -w /d moby/buildkit:latest
sudo nerdctl exec -ti buildkitd buildctl build --frontend dockerfile.v0 --local context=/d --local dockerfile=. --output type=oci,dest=radicale.tar,name=radicale
sudo nerdctl load -i radicale.tar
sudo nerdctl rm -f buildkitd

sudo nerdctl run --rm -ti -p 5232:5232 --name radicale radicale

### Apply in kubernetes
sudo nerdctl -n k8s.io load -i radicale.tar
kubectl create secret generic radicale-users --from-literal=users=$(cat secrets_users)
kubectl apply -f radicale.yaml


### Delete
k delete secret radicale-users
k delete -f radicale.yaml
