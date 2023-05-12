FROM perl:5.37.11

LABEL maintainer="Nicholas S. Castellano N2QZ <n2qz@n2qz.net>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        libpq-dev=13.11-0+deb11u1 \
        libpq5=13.11-0+deb11u1 \
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
