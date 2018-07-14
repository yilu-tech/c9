FROM alpine:3.5

# Install base and Node
RUN apk add --update --no-cache g++ make python tmux curl nodejs bash git

# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9 \
  && curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
  && /cloud9/scripts/install-sdk.sh \
  && apk del g++ make \
  && rm -rf /var/cache/apk/* /opt/cloud9/.git /tmp/* \
  && npm cache clean

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# install pm2
RUN npm i -g pm2

COPY startup.json /startup.json

CMD ["pm2-runtime", "startup.json"]