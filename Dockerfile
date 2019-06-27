FROM ubuntu:18.04

ENV NVM_DIR=/root/.nvm BORON=v6.16.0 STABLE=v11.7.0

COPY startup startup.json /

SHELL ["/bin/bash", "-c"]

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl build-essential g++ libssl-dev apache2-utils git libxml2-dev sshfs python tzdata locales vim tmux \
 && locale-gen en_US.UTF-8 \
 && git clone https://github.com/creationix/nvm.git $NVM_DIR \
 && cd $NVM_DIR \
 && git checkout `git describe --abbrev=0 --tags` \
 && source $NVM_DIR/nvm.sh \
 && echo "source ${NVM_DIR}/nvm.sh" > /root/.bashrc \
 && source /root/.bashrc \
 && nvm install $STABLE \
 && nvm install $BORON 

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN git clone https://github.com/c9/core.git /cloud9 \
 && /cloud9/scripts/install-sdk.sh \
 && sed -i "s|127.0.0.1|0.0.0.0|g" /cloud9/configs/standalone.js \
 && source $NVM_DIR/nvm.sh \
 && source /root/.bashrc \
 && nvm alias default $STABLE \
 && npm config set unsafe-perm true \
 && npm i -g pm2 \
 && apt-get remove -y python curl build-essential g++ libssl-dev libxml2-dev software-properties-common \
 && apt-get autoremove -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.c9/node /root/.c9/tmp && npm cache clean --force \
 && rm -rf /cloud9/.git \
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && mkdir -p /apps \
 && chmod +x /startup

COPY .bashrc /root/.bashrc

CMD ["/startup"]