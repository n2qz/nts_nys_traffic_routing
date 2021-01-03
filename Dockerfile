FROM perl:5.32.0-buster

LABEL maintainer="Nicholas S. Castellano N2QZ <n2qz@n2qz.net>"

ARG DEBIAN_FRONTEND=noninteractive

# No direct dependency on libp11-kit0.  Patching CVE-2020-29361.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       libp11-kit0=0.23.15-2+deb10u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY cpanfile /cpanfile

RUN mkdir /app
WORKDIR /app
RUN cpanm --installdeps --cpanfile /cpanfile .

COPY app /app

RUN chmod -R o+r /app
RUN chmod o+rx /app/app.pl

COPY nts_nys_traffic_routing.csv /
RUN chmod 644 /nts_nys_traffic_routing.csv

CMD ["/app/app.pl"]
