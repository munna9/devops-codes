FROM centos:7.3.1611
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
RUN useradd phenom -d /opt/deployment -u 1000 && \
    yum install wget -y -q
ONBUILD ARG JAVA_VERSION=8u131
ONBUILD ARG JAVA_BUILD=b11
ONBUILD RUN wget -O /tmp/jdk-8-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-$JAVA_VERSION-linux-x64.rpm"  && \
    yum install -y -q /tmp/jdk-8-linux-x64.rpm && \
    yum remove -y -q wget && \
    rm -rf /tmp/jdk-8-linux-x64.rpm
ONBUILD ENV JAVA_HOME /usr/java/default
ONBUILD ENV PATH $JAVA_HOME/bin:$PATH