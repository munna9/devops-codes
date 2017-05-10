#Base image

FROM centos:7.3.1611

MAINTAINER Rajesh Jonnalagadda "admin.squad@phenompeople.com"

ONBUILD RUN yum install -q -e 0 -y wget make perl gcc-c++ pcre-devel zlib-devel file && \
    useradd -d  /opt/phenom phenom && \
    mkdir -p /opt/phenom/scripts

LABEL project="nginx-lua"
ONBUILD ARG NGINX_VERSION=1.11.10
ONBUILD ARG OPENSSL_VERSION=1.0.2f
ONBUILD ARG PCRE_VERSION=8.40
ONBUILD ARG ZLIB_VERSION=1.2.11
ONBUILD ARG LUAJIT_VERSION=2.0.4
ONBUILD ARG NGINX_DEV_KIT_VERSION=v0.3.0
ONBUILD ARG NGINX_LUA_MOD_VERSION=v0.10.7

EXPOSE 80 443

ONBUILD ENV PCRE_VERSION=${PCRE_VERSION} \
    ZLIB_VERSION=${ZLIB_VERSION} \
    OPENSSL_VERSION=${OPENSSL_VERSION} \
    NGINX_VERSION=${NGINX_VERSION} \
    LUAJIT_VERSION=${LUAJIT_VERSION} \
    NGINX_DEV_KIT_VERSION=${NGINX_DEV_KIT_VERSION} \
    NGINX_LUA_MOD_VERSION=${NGINX_LUA_MOD_VERSION} \
    NGINX_SETUP_DIR='/opt/cache/nginx'

ONBUILD ADD setup /opt/phenom/scripts
ONBUILD RUN /opt/phenom/scripts/install.sh
ONBUILD COPY config/nginx.conf /etc/nginx/nginx.conf

ONBUILD VOLUME /usr/share/nginx/html \
       /etc/nginx/conf.d
ONBUILD RUN yum remove -q -e 0 -y wget make perl gcc-c++ pcre-devel zlib-devel file && \
    yum clean all
