cd ~/Code/CloudProject/cloud_project_terraform
terraform apply -auto-approve
terraform apply -auto-approve # To get output IP

# cd ~/Code/CloudProject/cloud_project_ansible
# check that variables are ok in Playbook

ssh-keygen -f "/home/rihards/.ssh/known_hosts" -R "95.216.206.226"
cd ~/Code/CloudProject/cloud_project_ansible
docker run -ti --rm -v ~/Code/CloudProject/cloud_project_ansible:/d -v ~/Code/CloudProject/Secrets/:/Secrets/ -v ~/.ssh/:/root/.ssh -w /d williamyeh/ansible:alpine3-onbuild sh -c 'apk add --no-cache openssh-client && \
eval "$(ssh-agent -s)"; ssh-add /root/.ssh/scaleway && \
ansible-playbook -i ./Inventory --limit production --vault-password-file ../Secrets/ansible_vault_pass -u root --diff Playbook.yml -e ansible_port=22'

ansible-playbook -i ./Inventory --limit production -u rihards --diff Playbook.yml

sudo mkdir /data
sudo mkdir /backups

cd ~/Code/work_in_progress/Kubernetes
SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
echo "source <(kubectl completion bash)" >> ~/.bashrc
sudo mkdir /acme
exit

SERVER_IP="95.216.206.226"; scp -P 3013 ${SERVER_IP}:/home/rihards/.kube/config ~/.kube/config

### Helm
helm init --upgrade
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

cd ~/Code/CloudProject/cloud_project_kubernetes/Traefik
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml
kubectl apply -f traefik-configmap.yml
kubectl apply -f traefik-deployment.yml
kubectl apply -f traefik-ui.yml
kubectl apply -f cheese.yml

# Netdata
cd ~/Code/CloudProject/cloud_project_kubernetes/Netdata
kubectl apply -f netdata-pub.yml
kubectl apply -f netdata-back.yml

### Nextcloud
cd ~/Code/Kubes/nextcloud




### Add nodes
SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013
kubeadm token create --print-join-command --ttl 0
exit

echo "KUBELET_EXTRA_ARGS=--fail-swap-on=false" | sudo tee /etc/default/kubelet
sudo apt-get purge -y kubeadm kubectl kubelet kubernetes-cni
sudo apt autoclean; sudo apt autoremove -y
sudo apt-get install -y kubeadm=1.13.3-00 kubectl=1.13.3-00 kubelet=1.13.3-00 kubernetes-cni=0.6.0-00

# sudo openvpn --config ~/OpenVPN/rihpc.ovpn
sudo kubeadm reset -f
sudo \
\
--ignore-preflight-errors="swap"

### Reset and delete resources
sudo kubeadm reset -f

cd ~/Code/CloudProject/cloud_project_terraform
terraform destroy -auto-approve


### sshuttle
SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013
## From master to local node
sshuttle -D -e 'ssh -i .ssh/scaleway' --python '/usr/bin/python3' -r rihards@163.172.162.100:3013 10.244.1.0/24
# This enables getting traffic from pods running on another node.
# Feels hacky, specified only 10.244.1.0/24, as it looks like each node has
# differrent 10.244.X.0 IP... Up for modification

sshuttle -D -e 'ssh -i .ssh/hetzner' --python '/usr/bin/python3' -r rihards@95.216.206.226:3013 10.244.1.0/24
sshuttle -e 'ssh -i ~/.ssh/hetzner' --python '/usr/bin/python3' -r rihards@95.216.206.226:3013 10.244.1.0/24



####### Kubernetes upgrade
# vi /etc/apt/preferences.d/kubernetes # for feature version upgrades
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.23.1

# For upgrade to v1.17.0 had to use --ignore-preflight-errors=all
# Likely because I only have single master node
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
