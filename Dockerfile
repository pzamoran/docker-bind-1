FROM ubuntu:focal-20200423 AS add-apt-repositories

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg \
  && apt-key adv --fetch-keys http://www.webmin.com/jcameron-key.asc \
  && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM ubuntu:focal-20200423

LABEL maintainer="sameer@damagehead.com"

ENV BIND_USER=bind \
  BIND_VERSION=9.16.1 \
  WEBMIN_VERSION=1.941 \
  DATA_DIR=/data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  bind9 bind9-host dnsutils \ 
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
