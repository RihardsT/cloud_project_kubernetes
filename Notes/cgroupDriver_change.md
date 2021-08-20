## Update files
sudo vi /var/lib/kubelet/config.yaml
  cgroupDriver: systemd

sudo vi /var/lib/kubelet/kubeadm-flags.env
  --cgroup-driver=systemd

## Update the Kubernetes ConfigMap
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/
kubectl get cm -n kube-system | grep kubelet-config

kubectl edit cm kubelet-config-1.22 -n kube-system
  cgroupDriver: systemd
