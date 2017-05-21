FROM ubuntu:16.04

MAINTAINER Ali R "ali--@gmail.com"

# Configures operative system dependencies
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 \
        libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip wget && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo


# Installs java
ENV JAVA_VERSION 8
ENV JAVA_UPDATE 72
ENV JAVA_BUILD 15
ENV JAVA_HOME /usr/lib/jvm/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}
RUN apt-get update && apt-get install ca-certificates curl \
        gcc libc6-dev libssl-dev make \
        -y --no-install-recommends && \
	mkdir -p /usr/lib/jvm && \
	curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
	--header "Cookie: oraclelicense=accept-securebackup-cookie;" \
	http://download.oracle.com/otn-pub/java/jdk/"${JAVA_VERSION}"u"${JAVA_UPDATE}"-b"${JAVA_BUILD}"/server-jre-"${JAVA_VERSION}"u"${JAVA_UPDATE}"-linux-x64.tar.gz \
	| tar xz -C /usr/lib/jvm && \
    apt-get remove --purge --auto-remove -y \
            gcc \
            libc6-dev \
            libssl-dev \
            make && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH $JAVA_HOME/bin:$PATH


ENV PYCHARM /opt/pycharm
RUN mkdir $PYCHARM
RUN wget https://download.jetbrains.com/python/pycharm-professional-2017.1.2.tar.gz -O - | tar xzv --strip-components=1 -C $PYCHARM
ENV PATH $PYCHARM/bin:$PATH
