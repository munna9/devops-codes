FROM phenompeople/centos-python:2.7.13
MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"
LABEL project="elastalert"
ADD requirements.txt /
RUN yum install -y wget && \
    pip install  -q -r requirements.txt


