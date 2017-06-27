#Base image
FROM centos:7.3.1611
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
ENV container docker
RUN useradd -d  /opt/deployment -u 1000 phenom && \
    yum install -q -e 0 -y wget make gcc-c++ openssl-devel zlib-devel && \
    mkdir -p /opt/deployment/scripts

ARG PYTHON_VERSION=3.5.1
ARG PYTHON_PIP_VERSION=9.0.1
ARG ELASTIC_DOC_VERSION=0.3.0
ARG MONGO_CONNECTOR_VERSION=2.5.0
ARG ELASTIC_VERSION=elastic2

ENV PIP_FORMAT=legacy \
    PYTHON_VERSION=${PYTHON_VERSION} \
    PYTHON_PIP_VERSION=${PYTHON_PIP_VERSION} \
    ELASTIC_DOC_VERSION=${ELASTIC_DOC_VERSION} \
    MONGO_CONNECTOR_VERSION=${MONGO_CONNECTOR_VERSION} \
    SETUP_DIRECTORY=/opt/python/cache

ADD setup/install.sh /opt/deployment/scripts/install.sh
RUN /opt/deployment/scripts/install.sh
ENTRYPOINT ["python3"]