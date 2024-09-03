sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=rudenspavasaris.id.lv

mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
echo "source <(kubectl completion bash)" >> ~/.bashrc

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yaml

SERVER_IP="65.108.246.228"; scp ${SERVER_IP}:/home/rihards/.kube/config ~/.kube/config

sudo kubeadm reset -f

# After traefik
curl -v http://localhost/
