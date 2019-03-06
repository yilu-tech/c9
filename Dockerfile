FROM ubuntu:16.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# ENV NVM_DIR=/root/.nvm BORON=lts/boron STABLE=stable 
ENV NVM_DIR=/root/.nvm BORON=v6.16.0 STABLE=v11.7.0

COPY startup startup.json /
COPY .bashrc /root/.bashrc

RUN apt-get update \
 && apt-get install -y curl build-essential g++ libssl-dev apache2-utils git libxml2-dev sshfs python tzdata locales \
 && locale-gen en_US.UTF-8 \
 && git clone https://github.com/creationix/nvm.git $NVM_DIR \
 && cd $NVM_DIR \
 && git checkout `git describe --abbrev=0 --tags` \
 && source $NVM_DIR/nvm.sh \
 && echo "source ${NVM_DIR}/nvm.sh" >> /root/.bashrc \
 && source /root/.bashrc \
 && nvm install $STABLE \
 && nvm install $BORON

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /

RUN git clone https://github.com/c9/core.git /cloud9 \
 && /cloud9/scripts/install-sdk.sh \
 && sed -i "s|127.0.0.1|0.0.0.0|g" /cloud9/configs/standalone.js

RUN source $NVM_DIR/nvm.sh \
 && source /root/.bashrc \
 && nvm alias default $STABLE \
 && npm config set unsafe-perm true \
 && npm i -g pm2 \
 && chmod +x /startup \
 && mkdir -p /apps \
 && apt-get remove -y python curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

CMD ["/startup"]