FROM ubuntu:16.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NVM_DIR=/root/.nvm BORON=lts/boron STABLE=stable

COPY startup startup.json /

RUN apt-get update \
 && apt-get install -y curl build-essential g++ libssl-dev apache2-utils git libxml2-dev sshfs python tzdata \
 && git clone https://github.com/creationix/nvm.git $NVM_DIR \
 && cd $NVM_DIR \
 && git checkout `git describe --abbrev=0 --tags` \
 && source $NVM_DIR/nvm.sh \
 && echo "source ${NVM_DIR}/nvm.sh" > /root/.bashrc \
 && source /root/.bashrc \
 && nvm install $STABLE \
 && nvm install $BORON

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