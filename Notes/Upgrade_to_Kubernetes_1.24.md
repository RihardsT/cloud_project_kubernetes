Remove some old flags:
```
sudo vi /var/lib/kubelet/kubeadm-flags.env
# remove --network-plugin
# Add for containerd
--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock
```
https://serverfault.com/questions/1104591/error-failed-to-parse-kubelet-flag-unknown-flag-network-plugin


Move swap flag to config file:
https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/
```
sudo vi /etc/kubernetes/kubeadm-kubelet-config.yaml
failSwapOn: false
```
For me, the default containerd config had `cri` plugin disabled,
thus needed to enable it, by commenting out `disabled_plugins` line in containerd config.toml
