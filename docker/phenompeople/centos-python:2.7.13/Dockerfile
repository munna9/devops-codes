#Base image
FROM centos:7.3.1611
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
ENV container docker
RUN useradd -d  /opt/deployment -u 501 phenom && \
    yum install -q -e 0 -y wget make gcc-c++ openssl-devel zlib-devel && \
    mkdir -p /opt/deployment/scripts 

ARG PYTHON_VERSION=2.7.13
ENV PYTHON_VERSION=${PYTHON_VERSION}
ENV SETUP_DIRECTORY=/opt/python/cache
ADD setup /opt/deployment/scripts
RUN /opt/deployment/scripts/install.sh && \
    yum clean all && \
    rm -rf /opt/deployment/scripts
ENTRYPOINT ["python2"]