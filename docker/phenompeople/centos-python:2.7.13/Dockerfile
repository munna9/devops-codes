#Base image
FROM centos:7.3.1611
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
ENV container docker
RUN useradd -d  /opt/deployment -u 1000 phenom && \
    yum install -q -e 0 -y wget make gcc-c++ openssl-devel zlib-devel && \
    mkdir -p /opt/deployment/scripts 

ARG PYTHON_VERSION=2.7.13
ARG PYTHON_PIP_VERSION=9.0.1
ENV PYTHON_VERSION=${PYTHON_VERSION} \
    PYTHON_PIP_VERSION=${PYTHON_PIP_VERSION} \
    SETUP_DIRECTORY=/opt/python/cache
ADD setup /opt/deployment/scripts
RUN /opt/deployment/scripts/install.sh && \
    yum clean all && \
    rm -rf /opt/deployment/scripts
ENTRYPOINT ["python2"]
