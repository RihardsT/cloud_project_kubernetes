filebeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=["elasticsearch:9200"]
filebeat setup --pipelines --modules haproxy

bin/ingest-convert.sh --input file:///tmp/haproxy.json --output file:///tmp/haproxy.conf

kubectl cp elastic/logstash-76788b6944-7t6tc:/tmp/haproxy.conf ./haproxy.conf



### Using Filebeat modules



[Exported fields](https://www.elastic.co/guide/en/beats/filebeat/current/exported-fields-haproxy.html) are coming from ElasticSearch pipeline. The pipeline is not run, if the logs are sent to Logstash first. Check this [forum entry](https://discuss.elastic.co/t/filebeat-6-apache2-module-fields-not-exported-to-logstash/109402).  
In short, the module fields are exported when Filebeat sends data straight to ElasticSearch.  




### TODO:
- [ ] Get fields exported even when sending to Logstash. Check this [forum entry](https://discuss.elastic.co/t/filebeat-6-apache2-module-fields-not-exported-to-logstash/109402).
