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


##### Easy build on cluster
# Run the Other_WIP/Docker_dind
docker build -t registry.gitlab.com/rudenspavasaris/cloud_project_terraform_oracle/radicale .
docker login registry.gitlab.com
# username git, and Gitlab token
docker push registry.gitlab.com/rudenspavasaris/cloud_project_terraform_oracle/radicale

# For Kubernetes to be able to pull from private registry
cat ~/.docker/config.json


### Registry credentials
kubectl create secret generic regcred \
  --from-file=.dockerconfigjson=/home/rihards/Code/cloud_project/cloud_project_kubernetes/Secrets/docker_auth.json \
  --type=kubernetes.io/dockerconfigjson
