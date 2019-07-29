FROM python:3-alpine

# add yaml, ara python module and SSH package.
RUN set -xe \
    && apk add --no-cache --purge -u sudo curl ca-certificates openssh-client openssl \
    && apk --update add --virtual .build-dependencies python-dev libffi-dev openssl-dev build-base \
    && pip install --no-cache --upgrade pyyaml ara[server] \
    && apk del --purge .build-dependencies \
    && mkdir -p /workingdir/.ara/server \
    && mkdir -p /workingdir/www/logs \
    && rm -rf /var/cache/apk/* /tmp/*
COPY settings.yaml /workingdir/.ara/server/
EXPOSE 8000 3000
WORKDIR /workingdir
ENTRYPOINT [export ARA_SETTINGS="/workingdir/.ara/server/settings.yaml", python3 /usr/local/lib/python3.7/site-packages/ara/server/__main__.py runserver]
