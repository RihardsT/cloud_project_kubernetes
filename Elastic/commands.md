### TODO:
- [x] Get fields exported even when sending to Logstash. Check this [forum entry](https://discuss.elastic.co/t/filebeat-6-apache2-module-fields-not-exported-to-logstash/109402).
- [x] Send logs to Logstash via http
- [ ] Eventually rewrite using official operators? https://www.elastic.co/elasticsearch-kubernetes
- [ ] Security: https://www.elastic.co/guide/en/x-pack/current/security-getting-started.html

### Up
kubectl apply -f elasticsearch.yml -f es_ingest.yml -f kibana.yml -f metricbeat_daemonset.yml -f ingress.yml

kubectl apply -f elasticsearch.yml -f es_data.yml -f es_ingest.yml -f ingress.yml
kubectl apply -f kibana.yml

Minimal:
kubectl apply -f elasticsearch.yml -f kibana.yml -f ingress.yml

### Deps
Set virtual memory on host for Elasticsearch production mode
`sysctl -w vm.max_map_count=262144`
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf


Setup dashboards
```
filebeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=["elasticsearch:9200"]
metricbeat setup -E setup.kibana.host=kibana:5601
# filebeat setup --pipelines --modules haproxy
```

### Using Filebeat modules
[Exported fields](https://www.elastic.co/guide/en/beats/filebeat/current/exported-fields-haproxy.html) are coming from ElasticSearch pipeline. The pipeline is not run, if the logs are sent to Logstash first. Check this [forum entry](https://discuss.elastic.co/t/filebeat-6-apache2-module-fields-not-exported-to-logstash/109402).  
In short, the module fields are exported when Filebeat sends data straight to ElasticSearch.  

#### Convert ingest pipeline to Logstash pipeline
Convert https://github.com/elastic/beats/blob/master/filebeat/module/haproxy/log/ingest/pipeline.json for Logstash.
Copy the file to Logstash container under temp and run this:
```
bin/ingest-convert.sh --input file:///tmp/haproxy.json --output file:///tmp/haproxy.conf
```
Put it in logstash.conf
Getting error:
```
{:exception=>"Invalid FieldReference: `[process][pid`"
```
The field in grok is defined as `%{NUMBER:[process][pid:long}`, but it should be `%{NUMBER:[process][pid]:long}`
Replace `:long}` with `]:long}` in the converted haproxy.conf.  

Mutate config requires further modification, as Logstash doesn't take field type `:long` into account.
```
mutate {
  convert => {
    "[destination][port]" => "integer"
    "[haproxy][connections][active]" => "integer"
    "[haproxy][connections][backend]" => "integer"
    "[haproxy][connections][frontend]" => "integer"
    "[haproxy][connections][retries]" => "integer"
    "[haproxy][connections][server]" => "integer"
    "[process][pid]" => "integer"
    "[source][port]" => "integer"
    "[temp][duration]" => "integer"
    "[haproxy][backend_queue]" => "integer"
    "[haproxy][bytes_read]" => "integer"
    "[haproxy][connection_wait_time_ms]" => "integer"
    "[haproxy][server_queue]" => "integer"
    "[haproxy][total_waiting_time_ms]" => "integer"
 }
}
```
Search `\%{[A-Z]*.[a-z_\[\]]*:long` in atom, `Alt + Enter` to select all, copy, paste in new file.  
Replace `:long` with ` => "integer"`.  
`sed -i 's/:long/ => "integer"/g' fields`  
Add the " double quotes where necessary.



### Sending logs to Logstash via http
```
curl -X POST http://logstash:8080/ \
  -H 'content-type: application/json' \
  -d '{"message": "hello world", "level": "info", "timestamp": "2019-07-11T17:15"}'
curl -X POST https://mon2.rudenspavasaris.id.lv/ \
  -H 'content-type: application/json' \
  -d '{"message": "hello world", "level": "info", "timestamp": "2019-07-11T17:15"}'

TODO: Find out how to filter out index from the message and send data to specified index in Logstash.
curl -X POST http://logstash:8080/ \
  -H 'content-type: application/json' \
  -d '{"message": "hello world", "index": "test-index"}'

BASE64_USER_PASS=$(echo -n "username:password" | base64)
curl -X POST http://rudenspavasaris.id.lv:3046/ \
  -H "Authorization: Basic ${BASE64_USER_PASS}" \
  -H 'content-type: content-type: application/json' \
  -d '{"message": "hello world", "level": "info", "timestamp": "2019-07-11T17:15"}'
```

### Logs straight to Elasticsearch
```
curl -X POST "https://mon2.rudenspavasaris.id.lv/twitter/_doc/?pretty" -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
```


### Kubernetes volume - hostPath
Elastic search container is running as `elasticsearch` user.  
To be able to write to hostPath, set permissions to allow root group to write:  
`chmod 755 /data/elasticsearch_data`



###
```
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["localhost:9200"]
  index: "api-access-%{+yyyy.MM.dd}"
setup.template:
  name: 'http'
  pattern: 'http-*'
  enabled: false
```
```
filebeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=["elasticsearch:9200"] -E output.elasticsearch.indices.index="http" -E setup.template.name="http" -E setup.template.pattern="http" -E setup.dashboards.index="http"


filebeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=["elasticsearch:9200"] -E output.elasticsearch.index="http-%{+yyyy.MM.dd}" -E setup.template.name="http" -E setup.template.pattern="http-*"


### User and role
curl -u elastic:changeme -X POST "elasticsearch:9200/_security/role/testrole?pretty" -H 'Content-Type: application/json' -d'
{
  "cluster": ["all"],
  "indices": [{
    "names": [ "test-*" ],
    "privileges": ["all"]}
  ]
}'

curl -u elastic:changeme -X PUT "kibana:5601/api/security/role/testrole" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "elasticsearch": {
    "cluster" : [ ],
    "indices" : [{
      "names": [ "test-*" ],
      "privileges": ["all"]}
    ]
  },
  "kibana": [
    {
      "base": ["all"],
      "feature": {},
      "spaces": ["testspace"]
    }
  ]
}'

curl -u elastic:changeme -X POST "elasticsearch:9200/_security/user/testuser?pretty" -H 'Content-Type: application/json' -d'
{ "password" : "testpassword",
  "roles" : [ "testrole" ]
}'

### Spaces
curl -u elastic:changeme -X POST "kibana:5601/api/spaces/space" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{ "id": "testspace",
  "name": "Test space",
  "color": "#aabbcc",
  "initials": "T" }'
curl -X POST "kibana:5601/s/testspace/api/saved_objects/index-pattern/test-*" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{"attributes": {
  "title": "test-*"
}}'

# Setup should be done before starting metricbeat,
# otherwise it will create index with default fields and dashboards will not work.
# Thus deleting the index before setup.
curl -u elastic:changeme -X DELETE "elasticsearch:9200/test-metricbeat-*"
metricbeat setup \
-E output.elasticsearch.username="elastic" \
-E output.elasticsearch.password="changeme" \
-E output.elasticsearch.hosts=["elasticsearch:9200"] \
-E output.elasticsearch.index="test-metricbeat-%{[agent.version]}-%{+yyyy.MM.dd}" \
-E setup.template.name="test" \
-E setup.template.pattern="test-*" \
-E setup.dashboards.index="test-*" \
-E setup.ilm.enabled=false \
-E setup.kibana.host=kibana:5601 \
-E setup.kibana.space.id="testspace" \
# -E setup.kibana.path="/s/testspace" # Another way how to load into specific space

# Delete the created metricbeat-* index pattern,
curl -u elastic:changeme -X DELETE "kibana:5601/s/testspace/api/saved_objects/index-pattern/metricbeat-*" -H 'kbn-xsrf: true'
# Create index, just to be sure, as metricbeat setup didn't seem to make it in space.
curl -u elastic:changeme -X POST "kibana:5601/s/testspace/api/saved_objects/index-pattern/test-*" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{"attributes": {
  "title": "test-*"
}}'

```



bin/logstash --config.test_and_exit
