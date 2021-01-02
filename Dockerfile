FROM nginx:1.19.6-perl

LABEL maintainer="Nicholas S. Castellano N2QZ <n2qz@n2qz.net>"

ARG DEBIAN_FRONTEND=noninteractive

# No direct dependency on libp11-kit0.  Patching CVE-2020-29361.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       libcgi-pm-perl=4.40-1 \
       libfcgi-perl=0.78-2+b3 \
       fcgiwrap=1.1.0-12 \
       libp11-kit0=0.23.15-2+deb10u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
 
COPY default.conf /etc/nginx/conf.d/default.conf

COPY fastcgi.sh /docker-entrypoint.d/99-fastcgi.sh
RUN chmod 0755 /docker-entrypoint.d/99-fastcgi.sh

COPY start-fcgiwrap /usr/local/bin
RUN chmod 755 /usr/local/bin/start-fcgiwrap

COPY html /usr/share/nginx/html
RUN chmod o+r /usr/share/nginx/html/*
RUN chmod o+rx /usr/share/nginx/html/nts_nys_traffic_routing.cgi

COPY nts_nys_traffic_routing.csv /
RUN chmod 644 /nts_nys_traffic_routing.csv
