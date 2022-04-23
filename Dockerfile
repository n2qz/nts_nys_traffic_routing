FROM perl:5.34.1-buster

LABEL maintainer="Nicholas S. Castellano N2QZ <n2qz@n2qz.net>"

ARG DEBIAN_FRONTEND=noninteractive

# Patching CVE-2022-1271
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       gzip=1.9-3+deb10u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY cpanfile /cpanfile

RUN mkdir /app
WORKDIR /app
RUN cpanm --installdeps --cpanfile /cpanfile .

COPY app /app

RUN chmod -R o+r /app \
    && chmod o+rx /app/app.pl

COPY nts_nys_traffic_routing.csv /
RUN chmod 644 /nts_nys_traffic_routing.csv

CMD ["/app/app.pl"]
