ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.7
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
    bash \
    jq \
    tzdata \
    nodejs=24.18.1-r0 \
    npm=11.12.1-r0

RUN npm install -g --no-audit --no-fund --unsafe-perm node-red@5.0.7 \
    && npm cache clean --force

COPY . /addon
WORKDIR /addon

RUN npm init -y >/dev/null 2>&1 || true \
    && npm install --no-audit --no-fund --unsafe-perm ws \
    && chmod a+x /addon/run.sh

ENTRYPOINT ["/addon/run.sh"]
