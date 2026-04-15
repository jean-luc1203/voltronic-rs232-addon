ARG BUILD_FROM=ghcr.io/hassio-addons/base-nodejs:0.2.1
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
    bash \
    jq \
    tzdata

RUN npm install -g --no-audit --no-fund --unsafe-perm node-red@4.1.4 \
    && npm cache clean --force

COPY . /addon
RUN chmod a+x /addon/run.sh

WORKDIR /addon
ENTRYPOINT ["/addon/run.sh"]
