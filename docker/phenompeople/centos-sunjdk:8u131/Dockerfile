FROM centos:7.3.1611

MAINTAINER Sandeep Alluri(<admin.squad@phenompeople.com>)

LABEL "project=sunjdk-8u131"

ARG APP_HOME=/opt/deployment
RUN useradd phenom -d ${APP_HOME} -u 1000 && \
    yum install wget -y -q

ONBUILD ARG JAVA_VERSION=8u131
ONBUILD ARG JAVA_DIR=jdk1.8.0_131
ONBUILD ARG JAVA_BUILD=b11

ONBUILD RUN  wget -q -O /tmp/jre-linux-x64.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
      "http://download.oracle.com/otn-pub/java/jdk/8u131-${JAVA_BUILD}/d54c1d3a095b4ff2b6607d096fa80163/jdk-${JAVA_VERSION}-linux-x64.tar.gz"  && \
     tar -xzf /tmp/jre-linux-x64.tar.gz -C /usr/local && \
     rm -f /usr/local/${JAVA_DIR}/jre/{COPYRIGHT LICENSE README THIRDPARTYLICENSEREADME.txt Welcome.html} && \
     ln -s /usr/local/${JAVA_DIR}/bin/java /usr/local/bin && \
     rm -rf /tmp/jre-linux-x64.tar.gz
ONBUILD ENV JAVA_HOME=/usr/local/${JAVA_DIR}
ONBUILD ENV PATH=$JAVA_HOME/bin:$PATH
