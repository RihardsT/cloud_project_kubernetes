https://www.elastic.co/downloads/elastic-cloud-kubernetes

https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-quickstart.html


# Create the custom resources and set up operator
kubectl create -f https://download.elastic.co/downloads/eck/2.5.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.5.0/operator.yaml
# Monitor the operator
kubectl -n elastic-system logs -f statefulset.apps/elastic-operator

# Set up Elasticsearch
cd ~/Code/cloud_project/cloud_project_kubernetes/Elastic/ECK
kubectl apply -f pv.yml
kubectl apply -f elasticsearch.yml

kubectl get elasticsearch
kubectl get pods --selector='elasticsearch.k8s.elastic.co/cluster-name=elasticsearch'


# Get elastic users password
kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo



# Quick up:
cd ~/Code/cloud_project/cloud_project_kubernetes/Elastic/ECK
kubectl create -f https://download.elastic.co/downloads/eck/2.5.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.5.0/operator.yaml
kubectl apply -f pv.yml
kubectl apply -f elasticsearch.yml

# Clear:
kubectl delete -f elasticsearch.yml
kubectl delete -f pv.yml
kubectl delete -f https://download.elastic.co/downloads/eck/2.5.0/operator.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/2.5.0/crds.yaml


### Fleet token
sudo ./elastic-agent install \
  --fleet-server-es=https://mon2.rudenspavasaris.id.lv:443 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NzE2NjA2NDkwODA6TloxSGVlV1BUYUtRTVEtc24yS2s4dw \
  --fleet-server-policy=fleet-server-policy

sudo /usr/bin/elastic-agent uninstall
sudo rm -rf /opt/Elastic/Agent/ # if that uninstall doesn't work.


http://elasticsearch-es-http.default.svc:9200
http://kibana-kb-http.default.svc:5601
