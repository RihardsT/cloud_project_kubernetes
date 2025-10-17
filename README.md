## About
Just setting up Kubernetes and learning various tools.

## To do:
- [ ] Set up ArgoCD with Helm instead and add the Trivy extension
- [ ] https://ubuntu.com/kubernetes/docs/explain-backups
- [ ] https://github.com/jp-gouin/helm-openldap
- [ ] https://github.com/prometheus-operator/kube-prometheus
- [ ] https://phoenixnap.com/kb/prometheus-kubernetes
      https://devopscube.com/setup-prometheus-monitoring-on-kubernetes/
- [ ] https://kubernetes.io/docs/concepts/architecture/nodes/ Read through and
      get worker nodes labeled and automatically set NoSchedule

kubectl taint nodes oc3 oc0=true:NoSchedule
kubectl taint nodes oc2 oc0=true:NoSchedule
kubeadm token create --print-join-command

tolerations:
- key: "oc0"
  operator: "Exists"
  effect: "NoSchedule"
