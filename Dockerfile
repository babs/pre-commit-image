FROM debian:bullseye-slim

COPY . /

RUN set -e \
    && useradd -ms /bin/bash -d /workdir user \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends python3-pip git \
    && pip3 install --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r /requirements.txt

WORKDIR /workdir
USER user
