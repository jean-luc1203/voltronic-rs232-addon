ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.7
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Node.js + outils système
RUN apk add --no-cache \
    bash \
    jq \
    tzdata \
    nodejs-lts \
    npm \
    python3 \
    make \
    g++ \
    linux-headers \
    build-base \
  || apk add --no-cache \
    bash \
    jq \
    tzdata \
    "nodejs~22" \
    "npm~10" \
    python3 \
    make \
    g++ \
    linux-headers \
    build-base

# Node-RED
RUN npm install -g --no-audit --no-fund --unsafe-perm node-red@4.1.4 \
    && npm cache clean --force

# Add-on
COPY . /addon
RUN chmod a+x /addon/run.sh

WORKDIR /addon
ENTRYPOINT ["/addon/run.sh"]
