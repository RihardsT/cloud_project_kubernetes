https://github.com/SonarSource/helm-chart-sonarqube/blob/master/charts/sonarqube/values.yaml

helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

cd ~/Code/cloud_project/cloud_project_kubernetes/SonarQube
kubectl create namespace sonarqube
kubectl apply -f netrc.yaml -f ingress.yaml -f jaxp_properties.yaml
helm upgrade --install --values helm-values.yaml -n sonarqube sonarqube sonarqube/sonarqube

Default Password:
admin:admin

helm uninstall -n sonarqube sonarqube
kubectl delete persistentvolumeclaims -n sonarqube data-sonarqube-postgresql-0


# For SonarQube 8.9.10
helm search repo sonarqube --versions
helm upgrade --install --values helm-values.yaml -n sonarqube sonarqube sonarqube/sonarqube-lts --version 1.0.31+449

# Scan:
sudo nerdctl run --rm -ti -e SONAR_HOST_URL=https://vieta.rudenspavasaris.id.lv -e SONAR_LOGIN=admin -e SONAR_PASSWORD=password -e SONAR_SCANNER_OPTS='-Dsonar.projectKey=TestProject' -v "${PWD}:/usr/src" sonarsource/sonar-scanner-cli
