# Nodes
curl -u elastic:changeme https://mon2.rudenspavasaris.id.lv/_cat/nodes

# Ingest data straight to Elasticsearch
curl -X POST -u elastic:changeme "https://mon2.rudenspavasaris.id.lv/test/_doc/?pretty" -H 'Content-Type: application/json' -d'{
  "@timestamp" : "2021-10-14T14:53:12", "message" : "trying out Elasticsearch"}'

curl -X POST -u elastic:changeme "https://mon4.rudenspavasaris.id.lv/test/_doc/?pretty" -H 'Content-Type: application/json' -d'{
  "@timestamp" : "2021-10-14T12:00:00", "message" : "trying out Elasticsearch"}'
