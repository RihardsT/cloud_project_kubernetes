cd ~/Code/CloudProject/cloud_project_terraform
terraform apply -auto-approve
terraform apply -auto-approve # To get output IP

# cd ~/Code/CloudProject/cloud_project_ansible
# check that variables are ok in Playbook

ssh-keygen -f "/home/rihards/.ssh/known_hosts" -R "163.172.162.100"
cd ~/Code/CloudProject/cloud_project_ansible
docker run -ti --rm -v ~/Code/CloudProject/cloud_project_ansible:/d -v ~/Code/CloudProject/Secrets/:/Secrets/ -v ~/.ssh/:/root/.ssh -w /d williamyeh/ansible:alpine3-onbuild sh -c 'apk add --no-cache openssh-client && \
eval "$(ssh-agent -s)"; ssh-add /root/.ssh/scaleway && \
ansible-playbook -i ./Inventory --limit production --vault-password-file ../Secrets/ansible_vault_pass -u root --diff Playbook.yml -e ansible_port=22'

cd ~/Code/work_in_progress/Kubernetes
SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013
mkdir .kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
echo "source <(kubectl completion bash)" >> ~/.bashrc
sudo mkdir /acme
exit

SERVER_IP="163.172.162.100"
scp -P 3013 ${SERVER_IP}:/home/rihards/.kube/config ~/.kube/config

### Helm
helm init --upgrade
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

cd ~/Code/work_in_progress/Kubernetes/Traefik
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
kubectl apply -f traefik-configmap.yml
kubectl apply -f traefik-deployment.yml
kubectl apply -f traefik-ui.yml
kubectl apply -f cheese.yml

# Netdata
cd ~/Code/work_in_progress/Kubernetes/Netdata
kubectl apply -f netdata-back.yml
kubectl apply -f netdata-pub.yml

### Nextcloud
cd ~/Code/Kubes/nextcloud




### Add nodes
SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013
kubeadm token create --print-join-command
exit

echo "KUBELET_EXTRA_ARGS=--fail-swap-on=false" | sudo tee /etc/default/kubelet
sudo apt-get purge -y kubeadm kubectl kubelet kubernetes-cni
sudo apt autoclean; sudo apt autoremove -y
sudo apt-get install -y kubeadm=1.13.3-00 kubectl=1.13.3-00 kubelet=1.13.3-00 kubernetes-cni=0.6.0-00

sudo openvpn --config ~/OpenVPN/rihpc.ovpn
sudo kubeadm reset -f
sudo \
 \
--ignore-preflight-errors="all"

### Reset and delete resources
sudo kubeadm reset -f

cd ~/Code/CloudProject/cloud_project_terraform
terraform destroy -auto-approve
