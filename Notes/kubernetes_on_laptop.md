#### Kubernetes on Laptop
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

```
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
# Change the root folder
sudo vi /etc/containerd/config.toml
  root = "/media/data/Other/containerd"
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd

sudo kubeadm reset -f
sudo kubeadm join ACTUAL_JOIN_COMMAND_HERE \
--ignore-preflight-errors="swap"
```
#### Not at all helpful
Note that this is still not enough to be able to use home laptop as worker node,
that would be reachable by other Kubernetes pods on "real" servers.  
That's still the dream.
