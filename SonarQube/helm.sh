https://github.com/SonarSource/helm-chart-sonarqube/blob/master/charts/sonarqube/values.yaml

helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

cd ~/Code/cloud_project/cloud_project_kubernetes/SonarQube
kubectl create namespace sonarqube
kubectl apply -f netrc.yml -f ingress.yml
helm upgrade --install --values helm-values.yml -n sonarqube sonarqube sonarqube/sonarqube

Default Password:
admin:admin

helm uninstall -n sonarqube sonarqube
kubectl delete persistentvolumeclaims -n sonarqube data-sonarqube-postgresql-0


# For SonarQube 8.9.10
helm search repo sonarqube --versions
helm upgrade --install --values helm-values.yml -n sonarqube sonarqube sonarqube/sonarqube-lts --version 1.0.31+449
