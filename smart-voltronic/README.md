# 🔋 Smart Voltronic – Home Assistant Add-on

Control and monitor your **Voltronic / Axpert inverters** directly from Home Assistant with an advanced command learning system, compatibility modes, and optional Premium analytics.

➡️ French documentation:
[https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README_FR.md](https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README_FR.md)

---

## ☕ Support development

Smart Voltronic is an open-source project developed during free time.

If you find it useful you can support development and unlock Premium features:

➡️ **Get Premium access here:**
[https://ko-fi.com/tapion69](https://ko-fi.com/tapion69)

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>

---

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-compatible-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)
![Premium](https://img.shields.io/badge/Premium-Available-gold)

---

# ⭐ Premium Features

Smart Voltronic Premium unlocks advanced monitoring, energy analytics and intelligent calculated sensors.

Premium is **optional** and the add-on remains fully functional without it.

Premium adds:

## 📊 Advanced energy analytics

Automatic calculation when inverter does not provide:

### Monthly energy:

* PV energy month
* Load energy month
* Grid energy month
* Battery charge month
* Battery discharge month

### Yearly energy:

* PV energy year
* Load energy year
* Grid energy year
* Battery charge year
* Battery discharge year

If the inverter already provides these values, Smart Voltronic always uses native values.

---

## ❤️ Battery health indicator

Provides an estimated battery health score based on:

* Daily usage patterns
* Charge cycles
* Operating conditions

⚠️ Informational indicator only.
Not a replacement for real battery diagnostics.

---

## 🩺 Inverter health indicator

Provides an estimated inverter condition score based on:

* Operating behaviour
* Fault frequency
* System stability indicators

⚠️ Informational indicator only.

---

## 📊 Daily energy distribution

Shows how your energy was supplied during the day:

* Solar contribution %
* Battery contribution %
* Grid contribution %

Allows understanding system behavior instantly.

---

## 🎨 Premium dashboard

Premium enables an advanced dashboard including:

* Energy distribution charts
* Monthly and yearly energy views
* Power history
* Battery health indicators
* Inverter health indicators
* Advanced diagnostics

---

# 🔑 How Premium licensing works

Premium is linked to your **Home Assistant Install ID**.

This prevents license sharing and ensures fair usage.

## Step 1 — Find your Install ID

Your Install ID is automatically published via MQTT.

Example topic:

```
voltronic/1/install_id
```

You can find it:

* In MQTT Explorer
* In Home Assistant MQTT integration
* In Smart Voltronic diagnostics sensors

---

## Step 2 — Purchase Premium

Purchase Premium via Ko-fi:

[https://ko-fi.com/tapion69](https://ko-fi.com/tapion69)

Send your **Install ID** when purchasing.

---

## Step 3 — Receive your Premium key

You will receive a Premium key linked to your Install ID.

---

## Step 4 — Activate Premium

Paste the key in add-on configuration:

```yaml
premium_key: YOUR_KEY_HERE
```

Restart the add-on.

Premium features will activate automatically.

---

# 🚀 What's new

## 🧠 Automatic inverter command learning

Smart Voltronic includes an intelligent learning engine that automatically identifies which commands are supported.

This allows:

* Better compatibility across firmware variants
* Prevention of unsupported commands
* Automatic adaptation of settings
* Creation of inverter compatibility profile
* Safer parameter changes

No user action required.

---

# 🧩 Configurable compatibility modes

Different Voltronic models behave differently.

Smart Voltronic provides compatibility modes.

Configured in add-on settings.

---

## Modern mode

Recommended for newer firmware.

Features:

* Uses command learning
* Modern firmware compatibility
* Protection against invalid commands

---

## Legacy mode

Recommended for older models.

Features:

* Uses command learning
* Legacy firmware compatibility
* Protection against invalid commands

---

## 2-choice source priority mode

Some inverters only support 2 priorities.

Allows:

* UI adaptation
* Prevent invalid commands
* Consistent behavior

Enable only if needed.

---

# 📸 Screenshots

## Device information

![Device](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/dashboard-overview.png)

---

## Settings

![Settings](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-settings.png)

---

## Power monitoring

![Power](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-power.png)

---

## Solar production

![PV](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-pv.png)

---

# 🔌 Connection methods

## Serial connection

Direct RS232 connection:

```
Inverter RJ45
↓
RJ45 → DB9 cable
↓
USB RS232 adapter
↓
Home Assistant
```

Recommended chipsets:

* FTDI
* PL2303

---

## Network gateway

Allows remote communication.

Supported:

* Elfin EE10A
* Elfin EW10A

Connection:

```
Inverter
↓
RS232
↓
Gateway
↓
Network
↓
Home Assistant
```

Gateway settings:

Serial:

```
2400 baud
8 data bits
1 stop bit
No parity
```

Network:

```
TCP Server
Port 8899
```

---

# ✨ Features

## Full monitoring

Automatic sensors:

* PV production
* Battery power
* Grid consumption
* Load power
* Voltages
* Currents
* Battery SOC
* Temperature
* Warnings
* Status

Refresh rate:

≈ 4 seconds

---

## Inverter control

Parameters:

* Output priority
* Charging priority
* Battery type
* Charging voltages
* Current limits

Every change is:

* Verified
* Confirmed
* Synchronized

---

# 🏠 Home Assistant integration

Automatic via MQTT discovery:

* Sensors
* Numbers
* Selects
* Switches
* Binary sensors

No manual YAML required.

---

# 🔧 Compatibility

Compatible with:

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* Clones

Thanks to learning system.

---

# ❤️ Contributing

Open source project.

Help welcome:

* Testing
* Feedback
* Documentation
* Improvements

---

# 🚀 Roadmap

Planned:

* More inverter models
* Premium analytics expansion
* Windows standalone version
* Advanced diagnostics
* Standalone GUI

---

# ⭐ If this project helps you

You can:

* Star the repository ⭐
* Share feedback
* Support development ☕

---

# 🔋 Smart inverter control fully integrated into Home Assistant

---
