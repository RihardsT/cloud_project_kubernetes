https://github.com/kubernetes-sigs/kind

### Install go lang and set podman alias to docker
go install sigs.k8s.io/kind@v0.14.0

##### Dpes for Rootless podman
echo 'GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"' | sudo tee -a /etc/default/grub
sudo update-grub

sudo mkdir /etc/systemd/system/user@.service.d
sudo vi /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=yes

sudo vi /etc/modules-load.d/iptables.conf
ip6_tables
ip6table_nat
ip_tables
iptable_nat

# Reboot

cd ~/Code/cloud_project_kubernetes/Kind
kind create cluster --config=${PWD}/config.yaml
##### Ingress Nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml # Example
curl localhost:8080/foo


### Clean up
kind delete cluster # cluster is the default name

### Useful commands
kubectl config get-contexts
kubectl config use-context CONTEXT # to switch to real K8s cluster

echo "127.0.0.1 kind.local" | sudo tee -a /etc/hosts
