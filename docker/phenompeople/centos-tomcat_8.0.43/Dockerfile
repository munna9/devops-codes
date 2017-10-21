FROM phenompeople/centos-sunjre:8u131

MAINTAINER Rajesh Jonnalagadda (<admin.squad@phenompeople.com>)

# Connector Port    : 8080
# Shutdown port     : 8005
# AJP Port          : 8009
# Redirect Port     : 8443

ONBUILD ARG TOMCAT_VERSION=8.0.43
ONBUILD ARG APP_HOME=/opt/deployment
ONBUILD ARG TOMCAT_HOME=${APP_HOME}/apache-tomcat

ONBUILD RUN wget -q -O /tmp/apache-tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
            tar xfz /tmp/apache-tomcat.tar.gz -C ${APP_HOME} && \
            mv ${APP_HOME}/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
            rm -rf /tmp/apache-tomcat.tar.gz && \
            rm -rf ${TOMCAT_HOME}/webapps/* && \
            rm -rf ${TOMCAT_HOME}/bin/*.bat && \
            rm -rf ${TOMCAT_HOME}/{LICENSE,NOTICE,RELEASE-NOTES,RUNNING.txt}

ONBUILD ENV CATALINA_HOME=${TOMCAT_HOME}
ONBUILD ENV CATALINA_BASE=${TOMCAT_HOME}
ONBUILD ENV CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9000 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=TomcatHostName"
ONBUILD ENV CATALINA_OUT=${CATALINA_BASE}/logs/catalina.out
ONBUILD ENV CATALINA_PID=${CATALINA_BASE}/bin/catalina.pid
ONBUILD EXPOSE 8080 8005 8009 8443 9000

