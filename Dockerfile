FROM python:3-alpine

# add yaml, ara python module and SSH package.
RUN set -xe \
    && apk add --no-cache --purge -u sudo curl ca-certificates openssh-client openssl \
    && apk --update add --virtual .build-dependencies python-dev libffi-dev openssl-dev build-base git \
    && pip install --no-cache --upgrade nodejs npm pyyaml ara[server] \
    && mkdir -p /workingdir/conf/server \
    && mkdir -p /workingdir/www/logs \
    && cd /workingdir && git clone https://github.com/ansible-community/ara-web && cd ara-web \
    && npm install \
    && apk del --purge .build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/*

COPY settings.yaml /workingdir/conf/server/
EXPOSE 8000 3000

VOLUME /workingdir

ENV ARA_SETTINGS="/workingdir/conf/server/settings.yaml"
ENTRYPOINT /usr/local/bin/ara-manage migrate && sleep 10 && /usr/local/bin/ara-manage runserver 0.0.0.0:8000 && npm start
