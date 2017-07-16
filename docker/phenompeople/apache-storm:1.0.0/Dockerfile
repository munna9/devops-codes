FROM phenompeople/centos-sunjdk
MAINTAINER Rajesh Jonnalagadda (<admin.squad@phenompeople.com>)
ONBUILD ARG STORM_VERSION=1.0.0
ONBUILD ENV STORM_VERSION=${STORM_VERSION}
ONBUILD ENV STORM_HOME=/opt/apache-storm-${STORM_VERSION}
ONBUILD RUN wget -q -O /tmp/apache-storm-${STORM_VERSION}.tar.gz "http://www-us.apache.org/dist/storm/apache-storm-${STORM_VERSION}/apache-storm-${STORM_VERSION}.tar.gz" && \
            tar -xzf /tmp/apache-storm-${STORM_VERSION}.tar.gz -C /opt && \
            mkdir -p ${STORM_HOME}/local && \
            rm -rf /tmp/apache-storm-${STORM_VERSION}.tar.gz && \
            ln -sf ${STORM_HOME} /opt/storm
ONBUILD ENV PATH=${STORM_HOME}:$PATH



