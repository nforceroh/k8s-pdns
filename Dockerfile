FROM docker.io/nforceroh/k8s-alpine-baseimage:latest

ARG \
  BUILD_DATE=now \
  VERSION=unknown

LABEL \
  maintainer="Sylvain Martin (sylvain@nforcer.com)"

ENV VERSION=4.8 \
  PDNS_guardian=yes \
  PDNS_setuid=pdns \
  PDNS_setgid=pdns \
  PDNS_launch=gmysql \
  MYSQL_ENV_MYSQL_HOST=db \
  MYSQL_ENV_MYSQL_PORT=3306 \
  MYSQL_ENV_MYSQL_USER=root \
  MYSQL_ENV_MYSQL_ROOT_PASSWORD=password \
  MYSQL_ENV_MYSQL_DATABASE=powerdns \
  MYSQL_ENV_MYSQL_PASSWORD=password

RUN apk add --no-cache \
    mariadb-client \
    pdns \
    pdns-backend-mysql \
    pdns-doc \
    py3-pip \
    python3

RUN pip3 install --no-cache-dir --break-system-packages envtpl

ADD rootfs /

RUN /bin/chmod 755 /etc/cont-init.d/*  /etc/services.d/powerdns/run /etc/services.d/powerdns/finish

EXPOSE 8080 53 53/udp

ENTRYPOINT ["/init"]