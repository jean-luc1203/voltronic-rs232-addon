#!/usr/bin/env bash
set -euo pipefail

echo "### RUN.SH SMART VOLTRONIC START ###"

if [ -f /usr/lib/bashio/bashio.sh ]; then
  # shellcheck disable=SC1091
  source /usr/lib/bashio/bashio.sh
  logi(){ bashio::log.info "$1"; }
  logw(){ bashio::log.warning "$1"; }
  loge(){ bashio::log.error "$1"; }
else
  logi(){ echo "[INFO] $1"; }
  logw(){ echo "[WARN] $1"; }
  loge(){ echo "[ERROR] $1"; }
fi

logi "Smart Voltronic: init..."

OPTS="/data/options.json"
FLOWS="/data/flows.json"
FLOWS_CRED="/data/flows_cred.json"
TMP="/data/flows.tmp.json"
INSTANCE_FILE="/data/smart_voltronic_instance_id"
DASHBOARDS_DIR="/config/dashboards"
ADDON_DATA_DIR="/data/smart-voltronic"
ADDON_FLOWS="/addon/flows.json"
ADDON_FLOWS_VERSION_FILE="/addon/flows_version.txt"
DATA_FLOWS_VERSION_FILE="/data/flows_version.txt"

mkdir -p /data
mkdir -p /config
mkdir -p "$DASHBOARDS_DIR"
mkdir -p "$ADDON_DATA_DIR"

if [ ! -f "$OPTS" ]; then
  loge "options.json introuvable dans /data. Stop."
  exit 1
fi

if [ ! -f "$ADDON_FLOWS" ]; then
  loge "flows.json introuvable dans /addon. Stop."
  exit 1
fi

# ============================================================
# HELPERS
# ============================================================
jq_str_or() {
  local jq_expr="$1"
  local fallback="$2"
  jq -r "($jq_expr // \"\") | if (type==\"string\" and length>0) then . else \"$fallback\" end" "$OPTS"
}

jq_int_or() {
  local jq_expr="$1"
  local fallback="$2"
  jq -r "($jq_expr // $fallback) | tonumber" "$OPTS" 2>/dev/null || echo "$fallback"
}

bool_or_false() {
  local jq_expr="$1"
  jq -r "($jq_expr // false) | if . == true then \"true\" else \"false\" end" "$OPTS"
}

trim() {
  local s="${1:-}"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

sanitize_transport() {
  local v
  v="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$v" in
    serial) echo "serial" ;;
    gateway|tcp) echo "tcp" ;;
    *) echo "serial" ;;
  esac
}

timezone_exists() {
  local tz="$1"
  [ -n "$tz" ] && [ -f "/usr/share/zoneinfo/$tz" ]
}

normalize_timezone() {
  local raw tz upper offset sign hours

  raw="$(trim "${1:-}")"
  [ -z "$raw" ] && { echo "UTC"; return; }

  tz="$raw"
  upper="$(printf '%s' "$tz" | tr '[:lower:]' '[:upper:]')"

  case "$upper" in
    UTC|ETC/UTC|GMT) echo "UTC"; return ;;
    EUROPE/FRANCE|FRANCE) echo "Europe/Paris"; return ;;
    BELGIUM) echo "Europe/Brussels"; return ;;
    GERMANY) echo "Europe/Berlin"; return ;;
    SPAIN) echo "Europe/Madrid"; return ;;
    ITALY) echo "Europe/Rome"; return ;;
    UK|ENGLAND|BRITAIN|GREAT\ BRITAIN) echo "Europe/London"; return ;;
    SOUTH\ AFRICA|AFRICA/SOUTH\ AFRICA|JOHANNESBURG) echo "Africa/Johannesburg"; return ;;
    MOROCCO) echo "Africa/Casablanca"; return ;;
    NEW\ YORK|US/EASTERN|EST) echo "America/New_York"; return ;;
    CHICAGO|US/CENTRAL|CST) echo "America/Chicago"; return ;;
    LOS\ ANGELES|US/PACIFIC|PST) echo "America/Los_Angeles"; return ;;
    MONTREAL) echo "America/Montreal"; return ;;
    DUBAI|UAE) echo "Asia/Dubai"; return ;;
    TOKYO|JAPAN) echo "Asia/Tokyo"; return ;;
    SYDNEY) echo "Australia/Sydney"; return ;;
  esac

  if printf '%s' "$upper" | grep -Eq '^(UTC|GMT)[[:space:]]*[+-][0-9]{1,2}(:00)?$'; then
    offset="$(printf '%s' "$upper" | sed -E 's/^(UTC|GMT)[[:space:]]*([+-][0-9]{1,2})(:00)?$/\2/')"
    sign="${offset:0:1}"
    hours="${offset:1}"
    hours="$(printf '%d' "$hours" 2>/dev/null || echo "")"
    if [ -n "$hours" ] && [ "$hours" -ge 0 ] && [ "$hours" -le 14 ]; then
      if [ "$sign" = "+" ]; then
        echo "Etc/GMT-$hours"
      else
        echo "Etc/GMT+$hours"
      fi
      return
    fi
  fi

  if printf '%s' "$upper" | grep -Eq '^[+-][0-9]{1,2}$'; then
    sign="${upper:0:1}"
    hours="${upper:1}"
    hours="$(printf '%d' "$hours" 2>/dev/null || echo "")"
    if [ -n "$hours" ] && [ "$hours" -ge 0 ] && [ "$hours" -le 14 ]; then
      if [ "$sign" = "+" ]; then
        echo "Etc/GMT-$hours"
      else
        echo "Etc/GMT+$hours"
      fi
      return
    fi
  fi

  echo "$tz"
}

validate_timezone_or_fallback() {
  local tz="$1"
  if timezone_exists "$tz"; then
    echo "$tz"
  else
    echo "UTC"
  fi
}

install_node_red_nodes() {
  export HOME="/data"
  export npm_config_cache="/data/.npm"
  export npm_config_update_notifier="false"
  export npm_config_fund="false"
  export npm_config_audit="false"

  mkdir -p /data
  cd /data

  if [ ! -f package.json ]; then
    logi "Initialisation package.json dans /data"
    npm init -y >/dev/null 2>&1
  fi

  local required_nodes=(
    "node-red-node-serialport"
  )

  local node
  for node in "${required_nodes[@]}"; do
    if [ ! -d "/data/node_modules/$node" ]; then
      logi "Installation du node Node-RED: $node"
      if npm install --unsafe-perm --no-audit --no-fund "$node"; then
        logi "Node installé avec succès: $node"
      else
        loge "Échec installation node: $node"
        exit 1
      fi
    else
      logi "Node déjà installé: $node"
    fi
  done
}

update_serial_config_by_name() {
  local node_name="$1"
  local serial_value="$2"
  local label="$3"

  if [ -z "$serial_value" ]; then
    logi "Serial ${label} non configuré, noeud conservé tel quel"
    return 0
  fi

  local exists
  exists="$(jq -r --arg name "$node_name" '.[] | select(.type=="serial-port" and .name==$name) | .name' "$FLOWS" 2>/dev/null || echo "")"

  if [ -z "$exists" ]; then
    logw "Noeud serial-port name '$node_name' introuvable dans flows.json (${label})"
    return 0
  fi

  jq --arg name "$node_name" --arg port "$serial_value" '
    map(
      if .type=="serial-port" and .name == $name
      then .serialport = $port
      else .
      end
    )
  ' "$FLOWS" > "$TMP" && mv "$TMP" "$FLOWS"

  logi "Port serial mis à jour : ${label} -> name=${node_name} port=${serial_value}"
}

update_tcp_host_port_by_name() {
  local node_name="$1"
  local host="$2"
  local port="$3"
  local label="$4"

  local exists
  exists="$(jq -r --arg name "$node_name" '.[] | select((.type=="tcp in" or .type=="tcp out" or .type=="tcp request") and .name==$name) | .name' "$FLOWS" 2>/dev/null || echo "")"

  if [ -z "$exists" ]; then
    logw "Noeud TCP name '$node_name' introuvable dans flows.json (${label})"
    return 0
  fi

  jq --arg name "$node_name" --arg host "$host" --arg port "$port" '
    map(
      if (.type=="tcp in" or .type=="tcp out" or .type=="tcp request") and .name == $name
      then .host = $host | .port = $port
      else .
      end
    )
  ' "$FLOWS" > "$TMP" && mv "$TMP" "$FLOWS"

  logi "TCP ${label} -> name=${node_name} host=${host} port=${port}"
}

# ============================================================
# PREMIUM
# ============================================================
if [ ! -f "$INSTANCE_FILE" ]; then
  cat /proc/sys/kernel/random/uuid > "$INSTANCE_FILE"
  logi "Premium: nouvel instance_id généré"
fi

SMART_VOLTRONIC_INSTANCE_ID="$(tr -d '\n\r' < "$INSTANCE_FILE")"
SMART_VOLTRONIC_PREMIUM_KEY="$(jq -r '.premium_key // ""' "$OPTS")"

export SMART_VOLTRONIC_INSTANCE_ID
export SMART_VOLTRONIC_PREMIUM_KEY

logi "Premium instance_id: $SMART_VOLTRONIC_INSTANCE_ID"
if [ -n "$SMART_VOLTRONIC_PREMIUM_KEY" ]; then
  logi "Premium key: configured"
else
  logi "Premium key: not configured"
fi

# ============================================================
# DASHBOARD
# ============================================================
DASHBOARD_CUSTOM_CARDS_INSTALLED="$(bool_or_false '.dashboard_custom_cards_installed')"
DASHBOARD_LANGUAGE="$(jq -r '.dashboard_language // "en"' "$OPTS")"

export DASHBOARD_CUSTOM_CARDS_INSTALLED
export DASHBOARD_LANGUAGE

logi "Dashboard custom cards installed: $DASHBOARD_CUSTOM_CARDS_INSTALLED"
logi "Dashboard language: $DASHBOARD_LANGUAGE"

# ============================================================
# OPTIONS
# ============================================================
SEND_BIP="$(jq -r '(.send_bip // true) | if . == true then "true" else "false" end' "$OPTS")"
export SEND_BIP
logi "Send bip enabled: $SEND_BIP"

# ============================================================
# MQTT
# ============================================================
MQTT_HOST="$(jq_str_or '.mqtt_host' '')"
MQTT_PORT="$(jq_int_or '.mqtt_port' 1883)"
MQTT_USER="$(jq -r '.mqtt_user // ""' "$OPTS")"
MQTT_PASS="$(jq -r '.mqtt_pass // ""' "$OPTS")"

logi "MQTT (options.json): ${MQTT_HOST:-<empty>}:${MQTT_PORT} (user: ${MQTT_USER:-<none>})"

if [ -z "$MQTT_HOST" ]; then
  loge "mqtt_host vide. Renseigne-le dans la config add-on."
  exit 1
fi

if [ -z "$MQTT_USER" ] || [ -z "$MQTT_PASS" ]; then
  loge "mqtt_user ou mqtt_pass vide. Renseigne-les dans la config add-on."
  exit 1
fi

# ============================================================
# TIMEZONE
# ============================================================
TZ_MODE_RAW="$(jq -r '.timezone_mode // "UTC"' "$OPTS")"
TZ_CUSTOM_RAW="$(jq -r '.timezone_custom // ""' "$OPTS")"

if [ "$TZ_MODE_RAW" = "CUSTOM" ]; then
  TZ_REQUESTED="$TZ_CUSTOM_RAW"
else
  TZ_REQUESTED="$TZ_MODE_RAW"
fi

TZ_REQUESTED="$(trim "$TZ_REQUESTED")"
TZ_NORMALIZED="$(normalize_timezone "$TZ_REQUESTED")"
ADDON_TIMEZONE="$(validate_timezone_or_fallback "$TZ_NORMALIZED")"

TIMEZONE_VALID="true"
if [ "$ADDON_TIMEZONE" != "$TZ_NORMALIZED" ]; then
  TIMEZONE_VALID="false"
fi

if [ -z "${ADDON_TIMEZONE:-}" ] || [ "$ADDON_TIMEZONE" = "null" ]; then
  ADDON_TIMEZONE="UTC"
  TIMEZONE_VALID="false"
fi

export TZ="$ADDON_TIMEZONE"
export ADDON_TIMEZONE
export ADDON_TIMEZONE_REQUESTED="${TZ_REQUESTED:-UTC}"
export ADDON_TIMEZONE_NORMALIZED="$TZ_NORMALIZED"
export ADDON_TIMEZONE_VALID="$TIMEZONE_VALID"

logi "Timezone requested: ${ADDON_TIMEZONE_REQUESTED}"
logi "Timezone normalized: ${ADDON_TIMEZONE_NORMALIZED}"
if [ "$ADDON_TIMEZONE_VALID" = "true" ]; then
  logi "Timezone active: ${ADDON_TIMEZONE}"
else
  logw "Timezone invalide ou inconnue -> fallback UTC (requested=${ADDON_TIMEZONE_REQUESTED}, normalized=${ADDON_TIMEZONE_NORMALIZED})"
  logi "Timezone active: ${ADDON_TIMEZONE}"
fi

# ============================================================
# BATTERY SYSTEM VOLTAGE
# ============================================================
BATTERY_SYSTEM_VOLTAGE_RAW="$(jq -r '.battery_system_voltage // "48V"' "$OPTS" | tr '[:lower:]' '[:upper:]' | tr -d ' ')"

case "$BATTERY_SYSTEM_VOLTAGE_RAW" in
  24|24V) BATTERY_SYSTEM_VOLTAGE="24" ;;
  48|48V) BATTERY_SYSTEM_VOLTAGE="48" ;;
  *) BATTERY_SYSTEM_VOLTAGE="48" ;;
esac

export BATTERY_SYSTEM_VOLTAGE
logi "Battery system voltage (options.json): ${BATTERY_SYSTEM_VOLTAGE}V"

# ============================================================
# INVERTER CONFIG
# ============================================================
INV1_LINK="$(jq -r '.inv1_link // "serial"' "$OPTS" | tr '[:upper:]' '[:lower:]')"
INV2_LINK="$(jq -r '.inv2_link // "serial"' "$OPTS" | tr '[:upper:]' '[:lower:]')"
INV3_LINK="$(jq -r '.inv3_link // "serial"' "$OPTS" | tr '[:upper:]' '[:lower:]')"

INV1_TRANSPORT="$(sanitize_transport "$INV1_LINK")"
INV2_TRANSPORT="$(sanitize_transport "$INV2_LINK")"
INV3_TRANSPORT="$(sanitize_transport "$INV3_LINK")"

SERIAL_1="$(jq -r '.inv1_serial_port // ""' "$OPTS")"
SERIAL_2="$(jq -r '.inv2_serial_port // ""' "$OPTS")"
SERIAL_3="$(jq -r '.inv3_serial_port // ""' "$OPTS")"

INV1_HOST="$(jq -r '.inv1_gateway_host // ""' "$OPTS")"
INV2_HOST="$(jq -r '.inv2_gateway_host // ""' "$OPTS")"
INV3_HOST="$(jq -r '.inv3_gateway_host // ""' "$OPTS")"

INV1_PORT="$(jq_int_or '.inv1_gateway_port' 8899)"
INV2_PORT="$(jq_int_or '.inv2_gateway_port' 8899)"
INV3_PORT="$(jq_int_or '.inv3_gateway_port' 8899)"

logi "Serial1: ${SERIAL_1:-<empty>}"
logi "Serial2: ${SERIAL_2:-<empty>}"
logi "Serial3: ${SERIAL_3:-<empty>}"

logi "Inv1 -> link: $INV1_LINK | transport: $INV1_TRANSPORT | host: ${INV1_HOST:-<empty>} | port: ${INV1_PORT}"
logi "Inv2 -> link: $INV2_LINK | transport: $INV2_TRANSPORT | host: ${INV2_HOST:-<empty>} | port: ${INV2_PORT}"
logi "Inv3 -> link: $INV3_LINK | transport: $INV3_TRANSPORT | host: ${INV3_HOST:-<empty>} | port: ${INV3_PORT}"

if [ "$INV1_TRANSPORT" = "tcp" ] && [ -z "$INV1_HOST" ]; then
  loge "Inv1: inv1_link=gateway mais inv1_gateway_host est vide dans la config."
  exit 1
fi
if [ "$INV2_TRANSPORT" = "tcp" ] && [ -z "$INV2_HOST" ]; then
  loge "Inv2: inv2_link=gateway mais inv2_gateway_host est vide dans la config."
  exit 1
fi
if [ "$INV3_TRANSPORT" = "tcp" ] && [ -z "$INV3_HOST" ]; then
  loge "Inv3: inv3_link=gateway mais inv3_gateway_host est vide dans la config."
  exit 1
fi

export INV1_TRANSPORT INV2_TRANSPORT INV3_TRANSPORT
export INV1_HOST INV2_HOST INV3_HOST
export INV1_PORT INV2_PORT INV3_PORT
export SERIAL_1 SERIAL_2 SERIAL_3

# ============================================================
# NODE-RED MODULES INSTALL
# ============================================================
install_node_red_nodes

# ============================================================
# FLOWS UPDATE
# ============================================================
ADDON_FLOWS_VERSION="$(cat "$ADDON_FLOWS_VERSION_FILE" 2>/dev/null || echo '0.0.0')"
INSTALLED_VERSION="$(cat "$DATA_FLOWS_VERSION_FILE" 2>/dev/null || echo '')"

if [ ! -f "$FLOWS" ] || [ "$INSTALLED_VERSION" != "$ADDON_FLOWS_VERSION" ]; then
  logi "Mise à jour flows : (installé: ${INSTALLED_VERSION:-aucun}) -> (addon: $ADDON_FLOWS_VERSION)"
  cp "$ADDON_FLOWS" "$FLOWS"
  echo "$ADDON_FLOWS_VERSION" > "$DATA_FLOWS_VERSION_FILE"
  logi "flows.json mis à jour vers v$ADDON_FLOWS_VERSION"
else
  logi "flows.json à jour (v$ADDON_FLOWS_VERSION), conservation des flows utilisateur"
fi

# ============================================================
# DASHBOARD STORAGE DIRS
# ============================================================
logi "Dashboard directories prepared: $DASHBOARDS_DIR"

# ============================================================
# PATCH SERIAL NODES
# ============================================================
update_serial_config_by_name "Serial inv 1" "$SERIAL_1" "SERIAL_1"
update_serial_config_by_name "Serial inv 2" "$SERIAL_2" "SERIAL_2"
update_serial_config_by_name "Serial inv 3" "$SERIAL_3" "SERIAL_3"

# ============================================================
# PATCH TCP NODES
# ============================================================
TCP1_HOST="$INV1_HOST"; TCP1_PORT="$INV1_PORT"
TCP2_HOST="$INV2_HOST"; TCP2_PORT="$INV2_PORT"
TCP3_HOST="$INV3_HOST"; TCP3_PORT="$INV3_PORT"

if [ "$INV1_TRANSPORT" = "serial" ]; then TCP1_HOST="127.0.0.1"; TCP1_PORT="1"; fi
if [ "$INV2_TRANSPORT" = "serial" ]; then TCP2_HOST="127.0.0.1"; TCP2_PORT="1"; fi
if [ "$INV3_TRANSPORT" = "serial" ]; then TCP3_HOST="127.0.0.1"; TCP3_PORT="1"; fi

update_tcp_host_port_by_name "tcp out inv 1" "$TCP1_HOST" "$TCP1_PORT" "OUT1"
update_tcp_host_port_by_name "tcp in inv 1"  "$TCP1_HOST" "$TCP1_PORT" "IN1"

update_tcp_host_port_by_name "tcp out inv 2" "$TCP2_HOST" "$TCP2_PORT" "OUT2"
update_tcp_host_port_by_name "tcp in inv 2"  "$TCP2_HOST" "$TCP2_PORT" "IN2"

update_tcp_host_port_by_name "tcp out inv 3" "$TCP3_HOST" "$TCP3_PORT" "OUT3"
update_tcp_host_port_by_name "tcp in inv 3"  "$TCP3_HOST" "$TCP3_PORT" "IN3"

# ============================================================
# MQTT BROKER PATCH
# ============================================================
if ! jq -e '.[] | select(.type=="mqtt-broker" and .name=="HA MQTT Broker")' "$FLOWS" >/dev/null 2>&1; then
  loge 'Aucun mqtt-broker nommé "HA MQTT Broker" trouvé dans flows.json'
  exit 1
fi

logi "Injection MQTT (broker/port/user) dans flows.json"

jq \
  --arg host "$MQTT_HOST" \
  --arg port "$MQTT_PORT" \
  --arg user "$MQTT_USER" \
  '
  map(
    if .type=="mqtt-broker" and .name=="HA MQTT Broker"
    then
      .broker=$host
      | .port=$port
      | .user=$user
    else .
    end
  )
  ' "$FLOWS" > "$TMP" && mv "$TMP" "$FLOWS"

# ============================================================
# FLOWS_CRED.JSON
# ============================================================
if [ -f "$FLOWS_CRED" ]; then
  rm -f "$FLOWS_CRED"
  logw "Ancien flows_cred.json supprimé"
fi

BROKER_ID="$(jq -r '.[] | select(.type=="mqtt-broker" and .name=="HA MQTT Broker") | .id' "$FLOWS")"

if [ -z "$BROKER_ID" ] || [ "$BROKER_ID" = "null" ]; then
  loge "Impossible de récupérer l'ID du node mqtt-broker dans flows.json"
  exit 1
fi

logi "Broker node ID: $BROKER_ID — Création flows_cred.json"

jq -n \
  --arg id "$BROKER_ID" \
  --arg user "$MQTT_USER" \
  --arg pass "$MQTT_PASS" \
  '{($id): {"user": $user, "password": $pass}}' \
  > "$FLOWS_CRED"

logi "flows_cred.json créé avec succès"

# ============================================================
# DASHBOARD INFO
# ============================================================
if [ "$DASHBOARD_CUSTOM_CARDS_INSTALLED" = "true" ]; then
  logi "Dashboard premium: mode custom cards activé"
else
  logw "Dashboard premium: mode dégradé natif HA actif tant que dashboard_custom_cards_installed=false"
fi

# ============================================================
# START NODE-RED
# ============================================================
export HOME="/data"
export NODE_PATH="/data/node_modules"
export TZ="$ADDON_TIMEZONE"

logi "Starting Node-RED sur le port 1892..."
exec node-red --userDir /data --settings /addon/settings.js
