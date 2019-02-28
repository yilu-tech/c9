FROM node:6-alpine

# set locale
ENV MUSL_LOCPATH="/usr/share/i18n/locales/musl"

RUN apk --no-cache add libintl \
 &&	apk --no-cache --virtual .locale_build add cmake make musl-dev gcc gettext-dev git \
 &&	git clone https://gitlab.com/rilian-la-te/musl-locales \
 &&	cd musl-locales && cmake -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
 &&	cd .. && rm -r musl-locales \
 &&	apk del .locale_build

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install cloud9
RUN apk add --update --no-cache g++ make python tmux curl bash git openssh-client tzdata \
 && git clone git://github.com/c9/core.git /cloud9 \
 && curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
 && /cloud9/scripts/install-sdk.sh \
 && apk del g++ make \
 && rm -rf /var/cache/apk/* /tmp/* \
 && npm cache clean \
 && sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js \
# install pm2
 && npm config set unsafe-perm true \
 && npm i -g pm2 \
 && mkdir -p /apps \
# set timezone
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY startup.json /startup.json

CMD ["pm2-runtime", "startup.json"]