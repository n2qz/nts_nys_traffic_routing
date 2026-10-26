FROM perl:5.44.0

LABEL maintainer="Nicholas S. Castellano N2QZ <n2qz@n2qz.net>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install \
        libbrotli-dev=1.1.0-2+deb13u1 \
        libbrotli1=1.1.0-2+deb13u1 \
        libheif-plugin-dav1d=1.23.6-2~deb13u1 \
        libheif-plugin-libde265=1.23.6-2~deb13u1 \
        libheif1=1.23.6-2~deb13u1 \
        libunbound8=1.26.2-0+deb13u1 \
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
