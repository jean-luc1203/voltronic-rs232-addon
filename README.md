# 🔋 Smart Voltronic – Home Assistant Add-on

Control and monitor your **Voltronic / Axpert inverters** directly from Home Assistant with advanced compatibility detection, automatic command learning, Premium dashboards and MQTT auto-discovery.

➡️ French documentation:
https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README_FR.md

---

## ☕ Support Development

Smart Voltronic is an open-source project developed during free time.

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-compatible-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)
![Premium](https://img.shields.io/badge/Premium-Available-gold)

---

# 🚀 What's New in v1.8.5

## ✨ New Premium HTML Dashboards

A completely redesigned dashboard experience is now available for Premium users.

### 🏠 Smart Energy House Dashboard

The new House Dashboard provides a complete overview of your installation:

- Real-time energy flow visualization
- Solar production monitoring
- Battery status and SOC tracking
- Grid import/export monitoring
- Home consumption overview
- Responsive design for desktop, tablet and mobile
- Automatic integration with Smart Energy modules

![Smart Energy House Dashboard](docs/images/dashboard%20house.png)

---

### ⚡ Global Flow Dashboard

The Global Flow Dashboard offers a detailed view of energy exchanges:

- Live power flow visualization
- Dynamic energy routing display
- Battery charge/discharge monitoring
- Solar, load and grid power analysis
- Advanced historical charts
- Optimized smartphone experience

![Global Flow Dashboard](docs/images/dashboard%20flux.png)

---

### 🚀 Automatic Dashboard Generation

Premium users now benefit from:

- Automatic dashboard generation
- Automatic dashboard updates
- English and French language support
- Responsive layouts for all screen sizes
- Seamless integration with Smart Energy modules

### 🧩 Dashboard Modes

Users can choose between:

- Legacy Lovelace Dashboard
- Premium HTML Dashboard
- Both dashboards simultaneously

---

# ⭐ Premium Features

Premium provides:

- Monthly and yearly PV energy fallback sensors
- Monthly and yearly Load energy fallback sensors
- Monthly and yearly battery energy sensors
- Battery health indicator
- Inverter health indicator
- Daily solar / battery / grid energy distribution
- Premium HTML dashboards
- Automatic dashboard generation

---

# 🔑 Premium Activation

Premium is linked to your Home Assistant Install ID.

1. Open **Settings → Devices & Services → MQTT**
2. Open **Smart Voltronic System**
3. Copy the Install ID sensor value
4. Purchase Premium via Ko-fi
5. Add your Premium key in addon configuration
6. Restart the addon

```yaml
premium_key: YOUR_KEY_HERE
```

---

# 🎨 Premium HTML Dashboards

Premium automatically enables advanced Smart Energy dashboards.

## House Dashboard

- Global installation overview
- Solar, battery and grid monitoring
- Responsive interface
- Multi-module integration

## Global Flow Dashboard

- Live power flows
- Energy routing visualization
- Historical charts
- Mobile optimized

---

# 📊 Free vs Premium

| Feature | Free | Premium |
|----------|------|----------|
| Daily PV Energy | ✅ | ✅ |
| Monthly PV Fallback | ❌ | ✅ |
| Yearly PV Fallback | ❌ | ✅ |
| Monthly Battery Energy | ❌ | ✅ |
| Yearly Battery Energy | ❌ | ✅ |
| Battery Health | ❌ | ✅ |
| Inverter Health | ❌ | ✅ |
| HTML Dashboards | ❌ | ✅ |

---

# 🧠 Automatic Command Learning

Smart Voltronic automatically detects supported commands and adapts to inverter firmware.

Benefits:

- Better compatibility
- Fewer communication errors
- Automatic adaptation
- Safer parameter changes

---

# 🧩 Compatibility Modes

### Modern Mode

Recommended for recent firmware.

### Legacy Mode

For older firmware.

### 2-Choice Priority Mode

Designed for inverters supporting only two priority options.

---

# 📸 Screenshots

## Device Information

![Device](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/dashboard-overview.png)

## Settings

![Settings](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-settings.png)

## Power Monitoring

![Power](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-power.png)

## Solar Production

![PV](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-pv.png)

---

# 🔌 Connection Methods

- Direct USB RS232 connection
- TCP Network Gateway connection

---

# ⚙️ Configuration Example

```yaml
inv1_link: serial
inv1_serial_port: /dev/serial/by-id/...

inv2_link: gateway
inv2_gateway_host: 192.168.1.40
inv2_gateway_port: 8899

premium_key: YOUR_KEY_HERE
```

---

# ✨ Features

### Monitoring

- PV production
- Battery power
- Grid consumption
- Load power
- Voltage
- Current
- SOC
- Temperature
- Alarms
- Status

Refresh rate: ~4 seconds

### Inverter Control

- Output priority
- Charger priority
- Battery type
- Charge voltages
- Current limits
- Grid settings

---

# 🏠 Home Assistant Integration

Automatic MQTT Discovery:

- Sensors
- Numbers
- Selects
- Switches
- Binary Sensors

No YAML required.

---

# 🔧 Compatibility

Supported families:

- Axpert
- VM
- MKS
- MAX
- MAX II
- MAX IV
- Compatible clones

---

# 🛠 Support

Use GitHub Issues for:

- Bug reports
- Compatibility reports
- Feature requests

---

# ❤️ Contribution

Contributions are welcome:

- Testing
- Feedback
- Documentation
- Improvements

---

# ⭐ If This Project Helps You

- Star the repository
- Share feedback
- Support development

---

# 🔋 Smart inverter control directly inside Home Assistant
