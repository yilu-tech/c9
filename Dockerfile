FROM node:6-alpine

# Install cloud9
RUN apk add --update --no-cache g++ make python tmux curl nodejs bash git \
 && git clone git://github.com/c9/core.git /cloud9 \
 && curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
 && /cloud9/scripts/install-sdk.sh \
 && apk del g++ make \
 && rm -rf /var/cache/apk/* /cloud9/.git /tmp/* \
 && npm cache clean \
 && sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js \
# install pm2
 && npm config set unsafe-perm true \
 && npm i -g pm2 \
 && mkdir -p /apps
COPY startup.json /startup.json

CMD ["pm2-runtime /startup.json"]