FROM centos:7.3.1611
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
ARG JAVA_VERSION=8u45
RUN useradd phenom -d /opt/deployment && \
    yum install wget -y -q && \
    wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-b14/jdk-$JAVA_VERSION-linux-x64.rpm" \
-O /tmp/jdk-8-linux-x64.rpm && \
    yum install -y -q /tmp/jdk-8-linux-x64.rpm && \
    yum remove -y -q wget && \
    rm -rf /tmp/jdk-8-linux-x64.rpm
ENV JAVA_HOME /usr/java/default
ENV PATH $JAVA_HOME/bin:$PATH