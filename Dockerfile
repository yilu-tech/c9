FROM node:8-alpine

# Install cloud9
RUN apk add --update curl build-base openssl-dev apache2-utils git libxml2-dev sshfs bash tmux python-dev py-pip \
 && git clone https://github.com/c9/core.git /cloud9 \
 && curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
 && /cloud9/scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# install pm2
RUN npm config set unsafe-perm true
RUN npm i -g pm2

RUN mkdir -p /apps
COPY startup.json /startup.json

CMD ["pm2-runtime", "startup.json"]