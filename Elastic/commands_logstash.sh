bin/logstash --config.test_and_exit

filter {
  mutate {
    lowercase => [ "[@metadata][beat]" ]
  }
}



- pipeline.id: upstream
  config.string: |
    input {
      http {
        codec => line
        host => "0.0.0.0"
        port => "8080"
      }
    }
    output {
      pipeline {
        if [@metadata][beat] in [pipeline.id] {
          send_to => [@metadata][beat]
        }
        else {
          send_to => [myVirtualAddress]
        }
      }
    }
- pipeline.id: downstream
  config.string: |
    input {
      pipeline {
        address => myVirtualAddress
      }
    }
    filter {
      json {
        skip_on_invalid_json => true
        source => "message"
        target => "parsedJson"
        id => "%{[parsedJson][index]}"
        add_field => { "index" => "%{[parsedJson][index]}" }
        remove_field => [ "parsedJson" ]
      }
      if [index] == '%{[parsedJson][index]}' {
        mutate {
          update => { "index" => "http-%{+YYYY.MM}" }
        }
      }
    }
    output {
      elasticsearch {
        hosts => "elasticsearch:9200"
        index => "%{index}"
      }
      stdout {
        codec  => rubydebug {
          metadata => true
        }
      }
    }
