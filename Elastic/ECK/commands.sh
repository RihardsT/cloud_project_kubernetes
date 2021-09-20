https://www.elastic.co/downloads/elastic-cloud-kubernetes

https://www.elastic.co/guide/en/cloud-on-k8s/1.7/k8s-quickstart.html


# Create the custom resources and set up operator
kubectl create -f https://download.elastic.co/downloads/eck/1.7.1/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.7.1/operator.yaml
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
kubectl create -f https://download.elastic.co/downloads/eck/1.7.1/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.7.1/operator.yaml
kubectl apply -f pv.yml
kubectl apply -f elasticsearch.yml

# Clear:
kubectl delete -f elasticsearch.yml
kubectl delete -f pv.yml
kubectl delete -f https://download.elastic.co/downloads/eck/1.7.1/operator.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/1.7.1/crds.yaml
