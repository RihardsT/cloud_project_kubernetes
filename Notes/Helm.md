### Install
https://github.com/helm/helm/releases

HELM_VERSION='3.13.2'
wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar -xzf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" linux-amd64/helm -O | sudo tee /usr/bin/helm >/dev/null
sudo chmod +x /usr/bin/helm

### General notes
```
# Main install notes
helm repo add REPO_NAME REPO_URL
helm repo update
helm install RELEASE_NAME CHART_NAME

# Get available chart versions
helm search repo REPO --versions
```
