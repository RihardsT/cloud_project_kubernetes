## The warning
When doing `kubeadm upgrade apply v1.22.1`
```
W0820 22:34:14.934476  577106 utils.go:69] The recommended value for "resolvConf" in "KubeletConfiguration" is: /run/systemd/resolve/resolv.conf; the provided value is: /etc/resolv.conf
```

sudo vi /var/lib/kubelet/config.yaml
  resolvConf: /run/systemd/resolve/resolv.conf

sudo vi /var/lib/kubelet/kubeadm-flags.env
  --resolv-conf=/run/systemd/resolve/resolv.conf

## Update the Kubernetes ConfigMap
kubectl edit cm kubelet-config-1.22 -n kube-system
  resolvConf: /run/systemd/resolve/resolv.conf
