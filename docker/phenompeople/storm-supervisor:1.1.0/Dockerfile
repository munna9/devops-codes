FROM phenompeople/apache-storm:1.1.0
MAINTAINER Rajesh Jonnalagadda (<admin.squad@phenompeople.com>)
EXPOSE 6700 6701 6702 6703 6704 6705 6706 6707 6708 6709 6710
COPY *-server.sh /opt/deployment/
RUN mkdir -p ${STORM_HOME}/logs && \
    touch ${STORM_HOME}/logs/supervisor.out && \
    chown -R phenom:phenom ${STORM_HOME}
USER phenom
ENTRYPOINT ["/opt/deployment/start-server.sh"]