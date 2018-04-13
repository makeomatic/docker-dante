FROM alpine:edge

# TODO: Various optional modules are currently disabled (see output of ./configure):
# - Libwrap is disabled because tcpd.h is missing.
# - BSD Auth is disabled because bsd_auth.h is missing.
# - ...

RUN set -ex \
  && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  # Runtime dependencies.
  && apk upgrade --no-cache \
  && apk add --no-cache \
    linux-pam \
    dante-server@testing \
    'su-exec>=0.2' \
  # Clean up.
  && rm -rf /tmp/*

# Default configuration
ADD root/ /

ENV CFGFILE /etc/sockd.conf
ENV PIDFILE /tmp/sockd.pid
ENV WORKERS 10

EXPOSE 1080

ENTRYPOINT ["./docker-init.sh"]
CMD sockd -f $CFGFILE -p $PIDFILE -N $WORKERS
