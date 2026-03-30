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

OPTS="/data/options.json"
FLOWS="/data/flows.json"
TMP="/data/flows.tmp.json"
INSTANCE_FILE="/data/smart_voltronic_instance_id"

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

sanitize_transport() {
  local v="${1,,}"
  case "$v" in
    gateway|tcp) echo "tcp" ;;
    *) echo "serial" ;;
  esac
}

is_valid_serial() {
  local p="${1:-}"
  [[ -n "$p" && "$p" != *CHANGE-ME* && ( "$p" == /dev/serial/* || "$p" == /dev/tty* ) ]]
}

is_valid_host() {
  local h="${1:-}"
  [[ -n "$h" && "$h" != *CHANGE-ME* ]]
}

is_valid_port() {
  local p="${1:-}"
  [[ "$p" =~ ^[0-9]+$ ]] && [ "$p" -ge 1 ] && [ "$p" -le 65535 ]
}

is_inv_enabled() {
  local transport="$1"
  local serial="$2"
  local host="$3"
  local port="$4"

  if [ "$transport" = "tcp" ]; then
    is_valid_host "$host" && is_valid_port "$port"
  else
    is_valid_serial "$serial"
  fi
}

# ============================================================
# GROUP / NODE ENABLE-DISABLE HELPERS
# ============================================================
get_group_ids_by_name() {
  local group_name="$1"
  jq -r --arg name "$group_name" '
    .[] | select(.type=="group" and .name==$name) | .id
  ' "$FLOWS" 2>/dev/null || true
}

set_disabled_by_group_name() {
  local group_name="$1"
  local disabled="$2"

  local group_ids
  group_ids="$(get_group_ids_by_name "$group_name")"

  if [ -z "$group_ids" ]; then
    logw "Groupe introuvable: ${group_name}"
    return 0
  fi

  while IFS= read -r gid; do
    [ -z "$gid" ] && continue

    jq --arg gid "$gid" --argjson disabled "$disabled" '
      map(
        if (.g? == $gid)
        then . + {disabled: $disabled}
        else .
        end
      )
    ' "$FLOWS" > "$TMP" && mv "$TMP" "$FLOWS"
  done <<< "$group_ids"

  if [ "$disabled" = true ]; then
    logi "Groupe '${group_name}' désactivé"
  else
    logi "Groupe '${group_name}' activé"
  fi
}

set_node_disabled_by_exact_name() {
  local node_name="$1"
  local disabled="$2"

  jq --arg name "$node_name" --argjson disabled "$disabled" '
    map(
      if (.name? == $name)
      then . + {disabled: $disabled}
      else .
      end
    )
  ' "$FLOWS" > "$TMP" && mv "$TMP" "$FLOWS"
}

set_inverter_runtime_state() {
  local inv="$1"
  local enabled="$2"

  local disabled=true
  if [ "$enabled" = true ]; then
    disabled=false
  fi

  set_disabled_by_group_name "onduleur ${inv}" "$disabled"
  set_disabled_by_group_name "apprentissage onduleur ${inv}" "$disabled"

  set_node_disabled_by_exact_name "Serial In ${inv}" "$disabled"
  set_node_disabled_by_exact_name "Serial Out ${inv}" "$disabled"
  set_node_disabled_by_exact_name "tcp in inv ${inv}" "$disabled"
  set_node_disabled_by_exact_name "tcp out inv ${inv}" "$disabled"

  if [ "$disabled" = true ]; then
    logi "INV${inv}: runtime désactivé"
  else
    logi "INV${inv}: runtime activé"
  fi
}

# ============================================================
# FLOW PATCH HELPERS
# ============================================================
update_serial_config_by_name() {
  local node_name="$1"
  local serial_value="$2"
  local label="$3"

  local exists
  exists="$(jq -r --arg name "$node_name" '.[] | select(.type=="serial-port" and .name==$name) | .name' "$FLOWS" 2>/dev/null || true)"

  if [ -z "$exists" ]; then
    logw "Noeud serial-port introuvable: ${node_name}"
    return 0
  fi

  if is_valid_serial "$serial_value"; then
    jq --arg name "$node_name" --arg port "$serial_value" '
      map(
        if .type=="serial-port" and .name == $name
        then .serialport = $port
        else .
        end
      )
    ' "$FLOWS" > "$TMP" && mv "$TMP" "$FLOWS"
    logi "${label}: serial=${serial_value}"
  else
    logi "${label}: port série non configuré"
  fi
}

update_tcp_host_port_by_name() {
  local node_name="$1"
  local host="$2"
  local port="$3"
  local label="$4"

  local exists
  exists="$(jq -r --arg name "$node_name" '.[] | select((.type=="tcp in" or .type=="tcp out" or .type=="tcp request") and .name==$name) | .name' "$FLOWS" 2>/dev/null || true)"

  if [ -z "$exists" ]; then
    logw "Noeud TCP introuvable: ${node_name}"
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

  logi "${label}: tcp=${host}:${port}"
}

# ============================================================
# PRECHECKS
# ============================================================
logi "Smart Voltronic: init..."

if [ ! -f "$OPTS" ]; then
  loge "options.json introuvable dans /data. Stop."
  exit 1
fi

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

# ============================================================
# DASHBOARD CUSTOM CARDS FLAG
# ============================================================
DASHBOARD_CUSTOM_CARDS_INSTALLED="$(jq -r '.dashboard_custom_cards_installed // false' "$OPTS")"
export DASHBOARD_CUSTOM_CARDS_INSTALLED

# ============================================================
# MQTT
# ============================================================
MQTT_HOST="$(jq_str_or '.mqtt_host' '')"
MQTT_PORT="$(jq_int_or '.mqtt_port' 1883)"
MQTT_USER="$(jq -r '.mqtt_user // ""' "$OPTS")"
MQTT_PASS="$(jq -r '.mqtt_pass // ""' "$OPTS")"

if [ -z "${MQTT_HOST}" ]; then
  loge "mqtt_host vide. Renseigne-le dans la config add-on."
  exit 1
fi

if [ -z "${MQTT_USER}" ] || [ -z "${MQTT_PASS}" ]; then
  loge "mqtt_user ou mqtt_pass vide. Renseigne-les dans la config add-on."
  exit 1
fi

# ============================================================
# TIMEZONE
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

INV1_ENABLED=false
INV2_ENABLED=false
INV3_ENABLED=false

if is_inv_enabled "$INV1_TRANSPORT" "$SERIAL_1" "$INV1_HOST" "$INV1_PORT"; then INV1_ENABLED=true; fi
if is_inv_enabled "$INV2_TRANSPORT" "$SERIAL_2" "$INV2_HOST" "$INV2_PORT"; then INV2_ENABLED=true; fi
if is_inv_enabled "$INV3_TRANSPORT" "$SERIAL_3" "$INV3_HOST" "$INV3_PORT"; then INV3_ENABLED=true; fi

export INV1_TRANSPORT INV2_TRANSPORT INV3_TRANSPORT
export INV1_HOST INV2_HOST INV3_HOST
export INV1_PORT INV2_PORT INV3_PORT
export SERIAL_1 SERIAL_2 SERIAL_3
export INV1_ENABLED INV2_ENABLED INV3_ENABLED

# ============================================================
# BOOT SUMMARY
# ============================================================
ACTIVE_INVS=()
[ "$INV1_ENABLED" = true ] && ACTIVE_INVS+=("1")
[ "$INV2_ENABLED" = true ] && ACTIVE_INVS+=("2")
[ "$INV3_ENABLED" = true ] && ACTIVE_INVS+=("3")

ACTIVE_INVS_STR="none"
if [ "${#ACTIVE_INVS[@]}" -gt 0 ]; then
  ACTIVE_INVS_STR="$(IFS=, ; echo "${ACTIVE_INVS[*]}")"
fi

logi "Config loaded -> timezone=${ADDON_TIMEZONE}, battery=${BATTERY_SYSTEM_VOLTAGE}V, mqtt=${MQTT_HOST}:${MQTT_PORT}, active_inverters=${ACTIVE_INVS_STR}"

if [ -n "$SMART_VOLTRONIC_PREMIUM_KEY" ]; then
  logi "Premium key: configured | instance_id=${SMART_VOLTRONIC_INSTANCE_ID}"
else
  logi "Premium key: not configured | instance_id=${SMART_VOLTRONIC_INSTANCE_ID}"
fi

if [ "$DASHBOARD_CUSTOM_CARDS_INSTALLED" = "true" ]; then
  logi "Dashboard custom cards: enabled"
else
  logw "Dashboard custom cards: disabled -> fallback dashboard mode"
fi

# ============================================================
# DASHBOARD STORAGE DIRS
# ============================================================
mkdir -p /config/dashboards
mkdir -p /data/smart-voltronic

# ============================================================
# FLOWS UPDATE
# ============================================================
ADDON_FLOWS_VERSION="$(cat /addon/flows_version.txt 2>/dev/null || echo '0.0.0')"
INSTALLED_VERSION="$(cat /data/flows_version.txt 2>/dev/null || echo '')"

if [ ! -f "$FLOWS" ] || [ "$INSTALLED_VERSION" != "$ADDON_FLOWS_VERSION" ]; then
  logi "Mise à jour flows : ${INSTALLED_VERSION:-aucun} -> ${ADDON_FLOWS_VERSION}"
  cp /addon/flows.json "$FLOWS"
  echo "$ADDON_FLOWS_VERSION" > /data/flows_version.txt
else
  logi "flows.json à jour (v${ADDON_FLOWS_VERSION})"
fi

# ============================================================
# PATCH SERIAL CONFIG NODES
# ============================================================
update_serial_config_by_name "Serial inv 1" "$SERIAL_1" "INV1"
update_serial_config_by_name "Serial inv 2" "$SERIAL_2" "INV2"
update_serial_config_by_name "Serial inv 3" "$SERIAL_3" "INV3"

# ============================================================
# PATCH TCP NODES
# Si non utilisé, valeur neutre
# ============================================================
TCP1_HOST="$INV1_HOST"; TCP1_PORT="$INV1_PORT"
TCP2_HOST="$INV2_HOST"; TCP2_PORT="$INV2_PORT"
TCP3_HOST="$INV3_HOST"; TCP3_PORT="$INV3_PORT"

if [ "$INV1_TRANSPORT" != "tcp" ] || [ "$INV1_ENABLED" != true ]; then TCP1_HOST="127.0.0.1"; TCP1_PORT="1"; fi
if [ "$INV2_TRANSPORT" != "tcp" ] || [ "$INV2_ENABLED" != true ]; then TCP2_HOST="127.0.0.1"; TCP2_PORT="1"; fi
if [ "$INV3_TRANSPORT" != "tcp" ] || [ "$INV3_ENABLED" != true ]; then TCP3_HOST="127.0.0.1"; TCP3_PORT="1"; fi

update_tcp_host_port_by_name "tcp out inv 1" "$TCP1_HOST" "$TCP1_PORT" "INV1 OUT"
update_tcp_host_port_by_name "tcp in inv 1"  "$TCP1_HOST" "$TCP1_PORT" "INV1 IN"

update_tcp_host_port_by_name "tcp out inv 2" "$TCP2_HOST" "$TCP2_PORT" "INV2 OUT"
update_tcp_host_port_by_name "tcp in inv 2"  "$TCP2_HOST" "$TCP2_PORT" "INV2 IN"

update_tcp_host_port_by_name "tcp out inv 3" "$TCP3_HOST" "$TCP3_PORT" "INV3 OUT"
update_tcp_host_port_by_name "tcp in inv 3"  "$TCP3_HOST" "$TCP3_PORT" "INV3 IN"

# ============================================================
# ENABLE / DISABLE RUNTIME NODES
# ============================================================
set_inverter_runtime_state "1" "$INV1_ENABLED"
set_inverter_runtime_state "2" "$INV2_ENABLED"
set_inverter_runtime_state "3" "$INV3_ENABLED"

# ============================================================
# MQTT BROKER PATCH
# ============================================================
if ! jq -e '.[] | select(.type=="mqtt-broker" and .name=="HA MQTT Broker")' "$FLOWS" >/dev/null 2>&1; then
  loge 'Aucun mqtt-broker nommé "HA MQTT Broker" trouvé dans flows.json'
  exit 1
fi

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

logi "MQTT broker patched -> ${MQTT_HOST}:${MQTT_PORT}"

# ============================================================
# FLOWS CREDENTIALS
# ============================================================
if [ -f /data/flows_cred.json ]; then
  rm -f /data/flows_cred.json
fi

BROKER_ID="$(jq -r '.[] | select(.type=="mqtt-broker" and .name=="HA MQTT Broker") | .id' "$FLOWS")"

if [ -z "$BROKER_ID" ]; then
  loge "Impossible de récupérer l'ID du node mqtt-broker dans flows.json"
  exit 1
fi

jq -n \
  --arg id "$BROKER_ID" \
  --arg user "$MQTT_USER" \
  --arg pass "$MQTT_PASS" \
  '{($id): {"user": $user, "password": $pass}}' \
  > /data/flows_cred.json

logi "flows_cred.json regenerated"

# ============================================================
# FINAL SUMMARY
# ============================================================
logi "INV1 -> transport=${INV1_TRANSPORT} enabled=${INV1_ENABLED}"
logi "INV2 -> transport=${INV2_TRANSPORT} enabled=${INV2_ENABLED}"
logi "INV3 -> transport=${INV3_TRANSPORT} enabled=${INV3_ENABLED}"

# ============================================================
# START NODE-RED
# ============================================================
logi "Starting Node-RED on port 1892..."
exec node-red --userDir /data --settings /addon/settings.js
