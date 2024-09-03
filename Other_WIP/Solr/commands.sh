https://hub.docker.com/_/solr/

https://github.com/docker-solr/docker-solr/tree/master

docker run --rm -d --name solr  -v "/data/solrdata:/var/solr" -p 8983:8983 solr:8.8.2-slim solr-precreate gettingstarted
