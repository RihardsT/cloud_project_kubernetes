### TODO:
- [x] Get fields exported even when sending to Logstash. Check this [forum entry](https://discuss.elastic.co/t/filebeat-6-apache2-module-fields-not-exported-to-logstash/109402).
- [x] Send logs to Logstash via http


Setup dashboards
```
filebeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=["elasticsearch:9200"]
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
curl -X POST http://localhost:8080/ \
  -H 'content-type: content-type: application/json' \
  -d '{"message": "hello world", "level": "info", "timestamp": "2019-07-11T17:15"}'
curl -X POST https://mon2.rudenspavasaris.id.lv/ \
  -H 'content-type: content-type: application/json' \
  -d '{"message": "hello world", "level": "info", "timestamp": "2019-07-11T17:15"}'
```
