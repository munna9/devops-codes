#Base image
FROM centos:7.3.1611
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
ENV container docker

ARG KIBANA_VERSION=5.3.0-1

LABEL project="kibana"

EXPOSE 5601

ADD kibana.repo /etc/yum.repos.d/kibana.repo

RUN yum install -y -q kibana-${KIBANA_VERSION} && \
    mkdir -p /opt/kibana/logs && \
    touch /opt/kibana/logs/kibana.log && \
    rm -rf /etc/yum.repos.d/kibana.repo && \
    yum clean all

ADD setup /opt/kibana

ENTRYPOINT ["/opt/kibana/scripts/kibana.sh"]

#docker run --name kibana -p 5601:5601 -e ELASTICSEARCH_URL="http://dev-elasticsearch01.aws.phenom.local:9200" -e KIBANA_INDEX="$USER" -td phenompeople/kibana:5.3.0