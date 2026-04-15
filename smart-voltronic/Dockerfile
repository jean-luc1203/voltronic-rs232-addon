ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.7
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Dépendances système
# On garde les outils de compilation dans l'image pour permettre
# l'installation runtime des nodes natifs dans /data si besoin.
RUN apk add --no-cache \
    bash \
    jq \
    tzdata \
    nodejs \
    npm \
    python3 \
    make \
    g++ \
    linux-headers \
    build-base

# Node-RED 4.x
RUN npm install -g --no-audit --no-fund --unsafe-perm node-red@4.1.4 \
    && npm cache clean --force

# Add-on
COPY . /addon
RUN chmod a+x /addon/run.sh

WORKDIR /addon
ENTRYPOINT ["/addon/run.sh"]
