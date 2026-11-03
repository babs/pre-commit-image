FROM python:3.14-slim-trixie AS base

LABEL org.opencontainers.image.source=https://github.com/babs/pre-commit-image

COPY . /

RUN set -e \
    && useradd -ms /bin/bash -d /workdir user \
    # Default every nodeenv install (pre-commit node hooks) to the current LTS, never "latest"
    && printf '[nodeenv]\nnode = lts\n' > /workdir/.nodeenvrc \
    && chown user:user /workdir/.nodeenvrc \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends git libatomic1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r /requirements.txt

WORKDIR /workdir
USER user

FROM base AS node
USER root
ADD --chmod=644 https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key /etc/apt/keyrings/nodesource.asc
ADD https://deb.nodesource.com/setup_lts.x /tmp/setup_lts.x
RUN set -e \
    # setup_lts.x pins the current LTS major: read it rather than run it (would need curl + gpg)
    && major="$(sed -n 's/^NODE_VERSION="\(.*\)"$/\1/p' /tmp/setup_lts.x)" \
    && [ -n "$major" ] \
    && rm /tmp/setup_lts.x \
    && printf 'Types: deb\nURIs: https://deb.nodesource.com/node_%s\nSuites: nodistro\nComponents: main\nSigned-By: /etc/apt/keyrings/nodesource.asc\n' "$major" \
        > /etc/apt/sources.list.d/nodesource.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs/nodistro \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER user

# Last stage = default `docker build` target
FROM base
