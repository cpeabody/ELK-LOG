
# This Dockerfile builds Centos6.6 with Elasticsearch/Kibanae
FROM eXploit-Jenkins:5000/exploit:latest

# Install JRE 1.7
RUN yum -y install java-1.7.0-openjdk.x86_64

ENV JAVA_HOME /usr/

# Install wget and tar
RUN yum -y install wget \
                   tar
WORKDIR /

###### install Elasticsearch #######################################################
ENV ES_PKG_NAME elasticsearch-1.7.3
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz
RUN tar xvzf $ES_PKG_NAME.tar.gz
RUN rm -f $ES_PKG_NAME.tar.gz
RUN mv /$ES_PKG_NAME /elasticsearch
VOLUME ["/data"]
WORKDIR /data
EXPOSE 9200
########## run logstash
WORKDIR /        
#RUN ./elasticsearch/bin/elasticsearch -d


###### install Kibana #######################################################
ENV KB_PKG_NAME kibana-4.1.2-linux-x64
WORKDIR /
RUN wget https://download.elastic.co/kibana/kibana/$KB_PKG_NAME.tar.gz
RUN tar xvzf $KB_PKG_NAME.tar.gz
RUN rm -f $KB_PKG_NAME.tar.gz
RUN mv /$KB_PKG_NAME /kibana
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml
EXPOSE 5601
########## run Kibana
WORKDIR /                    
#RUN /kibana/bin/kibana & disown                         


###### install Logstash #######################################################
ENV LG_PKG_NAME logstash-1.5.4
WORKDIR /
RUN wget https://download.elastic.co/logstash/logstash/$LG_PKG_NAME.tar.gz
RUN tar xvzf $LG_PKG_NAME.tar.gz
RUN rm -f $LG_PKG_NAME.tar.gz
RUN mv /$LG_PKG_NAME /logstash
ADD config/logstash.conf /logstash/bin/logstash.conf
EXPOSE 5001
########## run Logstash
WORKDIR /
#RUN /logstash/bin/logstash -f /logstash/bin/logstash.conf

######provide key
ADD config/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder.crt
ADD config/logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder.key

CMD /etc/crontab >> "@reboot  /start_script.sh"
ADD elk_start.sh /elk_start.sh
CMD chmod 755 /elk_start.sh

