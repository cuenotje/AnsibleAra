FROM python:3-alpine

# add yaml, ara python module and SSH package.
RUN set -xe \
    && apk add --no-cache --purge -u sudo curl ca-certificates openssh-client openssl \
    && apk --update add --virtual .build-dependencies python-dev libffi-dev openssl-dev build-base \
    && pip install --no-cache --upgrade pyyaml ara[server] \
    && apk del --purge .build-dependencies \
    && mkdir -p /workingdir \
    && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 8000
EXPOSE 3000
WORKDIR /workingdir
