FROM ubuntu:16.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NVM_DIR /usr/local/.nvm
ENV NODE_VERSION 6.14.3

RUN apt-get update

RUN apt-get install -y curl build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs
RUN git clone https://github.com/creationix/nvm.git $NVM_DIR \
 && cd $NVM_DIR \
 && git checkout `git describe --abbrev=0 --tags`
RUN source $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION

RUN echo "source ${NVM_DIR}/nvm.sh" > $HOME/.bashrc \
 && source $HOME/.bashrc

#ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules

RUN apt-get install -y python
RUN git clone https://github.com/c9/core.git /cloud9 \
 && /cloud9/scripts/install-sdk.sh \
 && sed -i "s|127.0.0.1|0.0.0.0|g" /cloud9/configs/standalone.js

COPY startup /startup
RUN chmod +x /startup
RUN mkdir -p /apps

WORKDIR /apps

CMD ["/startup"]