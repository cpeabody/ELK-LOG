#!/bin/bash

./elasticsearch/bin/elasticsearch -d

./kibana/bin/kibana & disown

./logstash/bin/logstash -f /logstash/bin/logstash.conf 
