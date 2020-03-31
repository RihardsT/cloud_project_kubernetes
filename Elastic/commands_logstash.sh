bin/logstash --config.test_and_exit

filter {
  mutate {
    lowercase => [ "[@metadata][beat]" ]
  }
}



curl -X POST http://logstash:8080/ \
  -H 'content-type: application/json' \
  -d '{"message": "testindex", "index": "testindex"}'
curl -X POST http://logstash:8080/ \
  -H 'content-type: application/json' \
  -d '{"message": "testindex"}'
curl -X POST http://logstash:8080/ \
  -H 'content-type:content-type: application/json' \
  -d '{"message": "testindex", "index": "testindex"}'
curl -X POST http://logstash:8080/ \
  -d 'Hello'




kubectl -n elastic annotate --overwrite pods logstash-65c9fbd69f-h28vf bump=2
