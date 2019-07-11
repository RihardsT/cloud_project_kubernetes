### TODO:
- [x] Get fields exported even when sending to Logstash. Check this [forum entry](https://discuss.elastic.co/t/filebeat-6-apache2-module-fields-not-exported-to-logstash/109402).

filebeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=["elasticsearch:9200"]
filebeat setup --pipelines --modules haproxy

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
```
{:exception=>"Invalid FieldReference: `[process][pid`"
```
The field in grok is defined as `%{NUMBER:[process][pid:long}`, but it should be `%{NUMBER:[process][pid]:long}`
Replace `:long}` with `]:long}` in the converted haproxy.conf.  
Similarly, `mutate{ convert => {"[haproxy][bytes_read]" => "long" }}` is unnecessary in logstash.conf, as the grok filter already sets the type to long.
