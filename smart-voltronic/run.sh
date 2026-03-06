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
if [ ! -f "$OPTS" ]; then
  loge "options.json introuvable dans /data. Stop."
  exit 1
fi

tmp="/data/flows.tmp.json"

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

sanitize_transport() {
  local v="$1"
  case "$v" in
    serial) echo "serial" ;;
    gateway|tcp) echo "tcp" ;;
    *) echo "serial" ;;
  esac
}

# ============================================================
# MQTT
# ============================================================
MQTT_HOST="$(jq_str_or '.mqtt_host' '')"
MQTT_PORT="$(jq_int_or '.mqtt_port' 1883)"
MQTT_USER="$(jq -r '.mqtt_user // ""' "$OPTS")"
MQTT_PASS="$(jq -r '.mqtt_pass // ""' "$OPTS")"

logi "MQTT (options.json): ${MQTT_HOST:-<empty>}:${MQTT_PORT} (user: ${MQTT_USER:-<none>})"

if [ -z "${MQTT_HOST}" ]; then
  loge "mqtt_host vide. Renseigne-le dans la config add-on."
  exit 1
fi

if [ -z "${MQTT_USER}" ] || [ -z "${MQTT_PASS}" ]; then
  loge "mqtt_user ou mqtt_pass vide. Renseigne-les dans la config add-on."
  exit 1
fi

# ============================================================
# Timezone
# ============================================================
TZ_MODE="$(jq -r '.timezone_mode // "UTC"' "$OPTS")"
TZ_CUSTOM="$(jq -r '.timezone_custom // "UTC"' "$OPTS")"

if [ "$TZ_MODE" = "CUSTOM" ]; then
  ADDON_TIMEZONE="$TZ_CUSTOM"
else
  ADDON_TIMEZONE="$TZ_MODE"
fi

if [ -z "${ADDON_TIMEZONE:-}" ] || [ "$ADDON_TIMEZONE" = "null" ]; then
  ADDON_TIMEZONE="UTC"
fi

export ADDON_TIMEZONE
logi "Timezone (options.json): $ADDON_TIMEZONE"

# ============================================================
# Battery system voltage
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
# Inverter config (BON FORMAT: inv1_*)
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

if [ "$INV1_TRANSPORT" = "tcp" ] && [ -z "${INV1_HOST}" ]; then
  loge "Inv1: inv1_link=gateway mais inv1_gateway_host est vide dans la config."
  exit 1
fi
if [ "$INV2_TRANSPORT" = "tcp" ] && [ -z "${INV2_HOST}" ]; then
  loge "Inv2: inv2_link=gateway mais inv2_gateway_host est vide dans la config."
  exit 1
fi
if [ "$INV3_TRANSPORT" = "tcp" ] && [ -z "${INV3_HOST}" ]; then
  loge "Inv3: inv3_link=gateway mais inv3_gateway_host est vide dans la config."
  exit 1
fi

export INV1_TRANSPORT INV2_TRANSPORT INV3_TRANSPORT
export INV1_HOST INV2_HOST INV3_HOST
export INV1_PORT INV2_PORT INV3_PORT
export SERIAL_1 SERIAL_2 SERIAL_3

# ============================================================
# flows.json update
# ============================================================
ADDON_FLOWS_VERSION="$(cat /addon/flows_version.txt 2>/dev/null || echo '0.0.0')"
INSTALLED_VERSION="$(cat /data/flows_version.txt 2>/dev/null || echo '')"

if [ ! -f /data/flows.json ] || [ "$INSTALLED_VERSION" != "$ADDON_FLOWS_VERSION" ]; then
  logi "Mise à jour flows : (installé: ${INSTALLED_VERSION:-aucun}) -> (addon: $ADDON_FLOWS_VERSION)"
  cp /addon/flows.json /data/flows.json
  echo "$ADDON_FLOWS_VERSION" > /data/flows_version.txt
  logi "flows.json mis à jour vers v$ADDON_FLOWS_VERSION"
else
  logi "flows.json à jour (v$ADDON_FLOWS_VERSION), conservation des flows utilisateur"
fi

# ============================================================
# Patch serial config nodes PAR ID
# ============================================================
update_serial_port() {
  local node_id="$1"
  local serial_value="$2"
  local label="$3"

  if [ -z "$serial_value" ]; then
    logi "Serial ${label} non configuré, noeud conservé tel quel"
    return 0
  fi

  local exists
  exists="$(jq -r --arg id "$node_id" '.[] | select(.id==$id) | .id' /data/flows.json 2>/dev/null || echo "")"

  if [ -z "$exists" ]; then
    logw "Noeud serial-port ID $node_id introuvable dans flows.json (${label})"
    return 0
  fi

  jq --arg id "$node_id" --arg port "$serial_value" '
    map(
      if .id == $id
      then .serialport = $port
      else .
      end
    )
  ' /data/flows.json > "$tmp" && mv "$tmp" /data/flows.json

  logi "Port serial mis à jour : ${label} -> ${serial_value}"
}

update_serial_port "c546b54ae425b9d2" "$SERIAL_1" "SERIAL_1"
update_serial_port "55a40ce3e960db15" "$SERIAL_2" "SERIAL_2"
update_serial_port "39e06a015d18096d" "$SERIAL_3" "SERIAL_3"

# ============================================================
# Patch TCP nodes PAR ID
# ============================================================
update_tcp_host_port() {
  local node_id="$1"
  local host="$2"
  local port="$3"
  local label="$4"

  local exists
  exists="$(jq -r --arg id "$node_id" '.[] | select(.id==$id) | .id' /data/flows.json 2>/dev/null || echo "")"

  if [ -z "$exists" ]; then
    logw "Noeud TCP ID $node_id introuvable dans flows.json (${label})"
    return 0
  fi

  jq --arg id "$node_id" --arg host "$host" --arg port "$port" '
    map(
      if .id == $id then
        .host = $host | .port = $port
      else .
      end
    )
  ' /data/flows.json > "$tmp" && mv "$tmp" /data/flows.json

  logi "TCP ${label} -> host=${host} port=${port}"
}

# En mode serial, valeurs neutres pour éviter NaN au boot
TCP1_HOST="$INV1_HOST"; TCP1_PORT="$INV1_PORT"
TCP2_HOST="$INV2_HOST"; TCP2_PORT="$INV2_PORT"
TCP3_HOST="$INV3_HOST"; TCP3_PORT="$INV3_PORT"

if [ "$INV1_TRANSPORT" = "serial" ]; then TCP1_HOST="127.0.0.1"; TCP1_PORT="1"; fi
if [ "$INV2_TRANSPORT" = "serial" ]; then TCP2_HOST="127.0.0.1"; TCP2_PORT="1"; fi
if [ "$INV3_TRANSPORT" = "serial" ]; then TCP3_HOST="127.0.0.1"; TCP3_PORT="1"; fi

# ond1
update_tcp_host_port "d3b0035141d1d3b7" "$TCP1_HOST" "$TCP1_PORT" "OUT1"
update_tcp_host_port "2dfc713b02835dce" "$TCP1_HOST" "$TCP1_PORT" "IN1"

# ond2
update_tcp_host_port "9a52731bd0e02253" "$TCP2_HOST" "$TCP2_PORT" "OUT2"
update_tcp_host_port "90e410c3b36fb2f7" "$TCP2_HOST" "$TCP2_PORT" "IN2"

# ond3
update_tcp_host_port "79ab6e02e4032a72" "$TCP3_HOST" "$TCP3_PORT" "OUT3"
update_tcp_host_port "8e40b345fa5c5f08" "$TCP3_HOST" "$TCP3_PORT" "IN3"

# ============================================================
# MQTT broker patch
# ============================================================
if ! jq -e '.[] | select(.type=="mqtt-broker" and .name=="HA MQTT Broker")' /data/flows.json >/dev/null 2>&1; then
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
  ' /data/flows.json > "$tmp" && mv "$tmp" /data/flows.json

# ============================================================
# flows_cred.json
# ============================================================
if [ -f /data/flows_cred.json ]; then
  rm -f /data/flows_cred.json
  logw "Ancien flows_cred.json supprimé"
fi

BROKER_ID="$(jq -r '.[] | select(.type=="mqtt-broker" and .name=="HA MQTT Broker") | .id' /data/flows.json)"

if [ -z "$BROKER_ID" ]; then
  loge "Impossible de récupérer l'ID du node mqtt-broker dans flows.json"
  exit 1
fi

logi "Broker node ID: $BROKER_ID — Création flows_cred.json"

jq -n \
  --arg id "$BROKER_ID" \
  --arg user "$MQTT_USER" \
  --arg pass "$MQTT_PASS" \
  '{($id): {"user": $user, "password": $pass}}' \
  > /data/flows_cred.json

logi "flows_cred.json créé avec succès"

logi "Starting Node-RED sur le port 1892..."
exec node-red --userDir /data --settings /addon/settings.js
