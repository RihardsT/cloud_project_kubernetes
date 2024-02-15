### Install
https://www.jenkins.io/doc/book/installing/kubernetes/

```
#Set up PV and service accounts
kubectl create namespace jenkins
kubectl apply \
-f https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-volume.yaml \
-f https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml
```
### Helm
https://github.com/jenkinsci/helm-charts/tree/main/charts/jenkins
```
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins

# Get default password
kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
```
