#Base image
FROM centos:7.3.1611
RUN yum install yum-utils -y && \
    yum -y groupinstall development && \
    yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum -y install python35u python35u-devel -y
RUN yum -y install python35u-pip && \
    pip3.5 install mongo-connector


