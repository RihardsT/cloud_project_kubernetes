After node restart had such error:
```
May 03 10:17:30 htz1 kubelet[4447]: E0503 10:17:30.426080    4447 bootstrap.go:265] part of the existing bootstrap client certificate is expired: 2020-04-19 15:03:37 +0000 UTC
May 03 10:17:30 htz1 kubelet[4447]: F0503 10:17:30.426118    4447 server.go:274] failed to run Kubelet: unable to load bootstrap kubeconfig: stat /etc/kubernetes/bootstrap-kubelet.conf: no such file or directory
```
Fix:
One was to update certs, but unsure if this was actually necessary.
`kubeadm alpha certs renew all`
This bit seemed to do the trick - use existing kubelet.conf for bootstrap
`cp /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf`

### K0s
Not able to read logs - No agent available
```
k logs --follow -n kube-system kube-proxy-..,
Error from server: Get "...": No agent available
```
https://docs.k0sproject.io/stable/networking/
Issue was that required konnectivity port 8132 was closed.
Without it opened (both in firewall and iptables on some cloud),
it errored out.
