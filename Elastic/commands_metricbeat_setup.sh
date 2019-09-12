### Metricbeat setup in default space - for easy testing

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
-E setup.kibana.host=kibana:5601

# Delete the created metricbeat-* index pattern,
curl -u elastic:changeme -X DELETE "kibana:5601/api/saved_objects/index-pattern/metricbeat-*" -H 'kbn-xsrf: true'
# Create index, just to be sure, as metricbeat setup didn't seem to make it in space.
curl -u elastic:changeme -X POST "kibana:5601/api/saved_objects/index-pattern/test-*" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{"attributes": {
  "title": "test-*"
}}'
