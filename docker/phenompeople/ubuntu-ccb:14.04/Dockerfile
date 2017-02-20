FROM ubuntu:trusty
MAINTAINER Rajesh Jonnalagadda "rajesh.jonnalagadda@phenompeople.com"
#Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV contianer docker
#Package section
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl
RUN apt-get update && \
	apt-get install -y sudo openssh-server curl lsb-release upstart
#User creation steps

RUN if ! getent passwd kitchen; then \
    useradd -d /home/kitchen -m -s /bin/bash -p '*' kitchen; \
    fi && \
    echo "kitchen ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Defaults !requiretty" >> /etc/sudoers && \
    mkdir -p /home/kitchen/.ssh && \
    chmod 0700 /home/kitchen/.ssh && \
    touch /home/kitchen/.ssh/authorized_keys && \
    chmod 0600 /home/kitchen/.ssh/authorized_keys && \
    chown -R kitchen:kitchen /home/kitchen/.ssh
#Chef client installation
RUN curl -O https://packages.chef.io/files/stable/chef/12.17.44/ubuntu/16.04/chef_12.17.44-1_amd64.deb && \
    dpkg -i chef_12.17.44-1_amd64.deb && \
    rm -f chef_12.17.44-1_amd64.deb && \
    apt-get clean all
#busser installation
RUN GEM_HOME=/tmp/verifier/gems \
    GEM_PATH=/tmp/verifier/gems \
    GEM_CACHE=/tmp/verifier/gems/cache \
    /opt/chef/embedded/bin/gem install \
    --no-rdoc --no-ri --no-format-executable \
    --bindir /tmp/verifier/bin --no-user-install \
    bundler \
    busser \
    busser-bash \
    busser-serverspec \
    serverspec \
    serverspec_extensions \
    thor \
    yarjuf \
    && chown -R kitchen:kitchen /tmp/verifier
#Fix for Chef language
ENV LANG=en_US.UTF-8
