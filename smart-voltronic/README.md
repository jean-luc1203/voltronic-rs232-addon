# 🔋 Smart Voltronic – Home Assistant Add-on

Control and monitor your **Voltronic / Axpert inverters** directly from Home Assistant with an advanced command learning system, configurable compatibility modes and optional Premium features.

➡️ French documentation:  
https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README_FR.md

## ☕ Support development

Smart Voltronic is an open-source project developed in free time.

If you find it useful you can support development and unlock Premium features:

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-compatible-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)
![Premium](https://img.shields.io/badge/Premium-Available-gold)

---

# 🚀 What's new

## ⭐ Premium features

Smart Voltronic Premium unlocks advanced monitoring and calculated values when some data is not provided by the inverter.

The add-on remains fully functional without Premium.

Premium enables:

* Monthly and yearly PV fallback sensors (only if inverter does not provide them)
* Monthly and yearly Load fallback sensors (only if inverter does not provide them)
* Monthly and yearly Battery energy sensors
* Battery health indicator
* Inverter health indicator
* Daily solar / battery / grid percentage distribution
* Advanced Premium dashboard

---

# 🔑 How to activate Premium

Premium is linked to your **Home Assistant Install ID**.

## Step 1 — Find your Install ID

Go to:

**Settings → Devices & Services → MQTT**

Open:

**Smart Voltronic System**

You will find the **Install ID sensor**.

---

## Step 2 — Purchase Premium

Purchase Premium via Ko-fi:

https://ko-fi.com/tapion69

Send your Install ID when purchasing.

---

## Step 3 — Activate Premium

Add your key in addon configuration:

premium_key: YOUR_KEY_HERE

Restart the addon.

Premium activates automatically.

---

# 📊 Free vs Premium logic

Smart Voltronic always prioritizes **native inverter values**.

Premium only provides fallback calculations when data is missing.

---

## PV energy

Daily PV:
✔ Free

Monthly PV:
✔ Free if inverter provides value  
⭐ Premium fallback if missing

Yearly PV:
✔ Free if inverter provides value  
⭐ Premium fallback if missing

---

## Load energy

Daily Load:
✔ Free

Monthly Load:
✔ Free if inverter provides value  
⭐ Premium fallback if missing

Yearly Load:
✔ Free if inverter provides value  
⭐ Premium fallback if missing

---

## Battery energy

Daily battery charge / discharge:
✔ Free

Monthly battery energy:
⭐ Premium only

Yearly battery energy:
⭐ Premium only

---

## Grid energy

Grid values only exist if inverter provides grid data.

Daily grid:
✔ Free if supported

Monthly grid:
✔ Free if supported  
⭐ Premium fallback if missing

Yearly grid:
✔ Free if supported  
⭐ Premium fallback if missing

If inverter does not provide grid data Smart Voltronic cannot estimate it reliably.

---

## ❤️ Health indicators

Premium adds:

* Battery Health score
* Inverter Health score

⚠️ These values are informational only.

---

## 📊 Daily energy distribution

Premium adds daily percentage sensors showing:

* Solar %
* Battery %
* Grid %

Shows how your load was powered.

---

## 🎨 Premium dashboard

Premium enables an advanced visual dashboard including:

* Energy distribution charts
* Monthly and yearly energy views
* Power history
* Health indicators
* Diagnostics overview

Dashboard is created automatically when Premium is active.

---

## 🧠 Automatic inverter command learning

Smart Voltronic includes an intelligent learning engine that automatically identifies which commands are actually supported by your inverter.

This allows:

* Better compatibility across Voltronic firmware variants
* Prevention of unsupported commands
* Automatic adaptation of available settings
* Creation of an inverter compatibility profile
* Safer parameter changes

No user action required.

---

## 🧩 Configurable compatibility modes

Different Voltronic models and firmware versions may behave differently.

Smart Voltronic provides compatibility modes to adapt the internal behavior depending on your inverter.

These modes are configurable in the add-on settings.

---

### Modern mode

Recommended for recent models and newer firmware.

Features:

* Uses the automatic command learning system
* Behavior adapted for modern inverter firmware
* Improved compatibility with newer models
* Protection against invalid commands

---

### Legacy mode

Recommended for older firmware or legacy inverter models.

Features:

* Also uses the automatic command learning system
* Behavior adapted for older inverter logic
* Improved compatibility with legacy devices
* Protection against invalid commands

---

### 2-choice source priority mode

Some inverters support only 2 power priority modes instead of 3.

This mode allows:

* Adapting Home Assistant available options
* Avoiding unsupported settings
* Keeping UI consistent with inverter behavior

Enable only if your inverter requires it.

---

# ⭐ Why Smart Voltronic is different

Smart Voltronic does more than just sending commands.

It adapts to your inverter.

Advantages:

* Better compatibility
* Fewer configuration errors
* Less manual setup
* Support for many firmware variants
* More reliable installation

Goal:

**Make the integration as plug and play as possible.**

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

Two connection types supported.

## Serial connection

Direct RS232 connection.

Inverter RJ45  
↓  
RJ45 → DB9 cable  
↓  
USB RS232 adapter  
↓  
Home Assistant  

Recommended chipsets:

* FTDI
* Prolific PL2303

---

## Network gateway connection

Allows remote communication over network.

Supported modules:

* Elfin EE10A
* Elfin EW10A

Connection:

Inverter  
↓  
RS232  
↓  
Gateway  
↓  
Network  
↓  
Home Assistant  

Gateway configuration:

Serial:

2400 baud  
8 data bits  
1 stop bit  
No parity  

Network:

TCP Server  
Port 8899  

---

# ⚙️ Configuration

Example:

inv1_link: serial  
inv1_serial_port: /dev/serial/by-id/...  

inv2_link: gateway  
inv2_gateway_host: 192.168.1.40  
inv2_gateway_port: 8899  

premium_key: YOUR_KEY_HERE  

MQTT topics:

voltronic/1/  
voltronic/2/  
voltronic/3/  

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

Configurable parameters:

* Output priority
* Charging priority
* Battery type
* Charging voltages
* Current limits
* Grid parameters

Every change is:

* Verified
* Confirmed
* Synchronized

---

# 🏠 Home Assistant integration

Automatic creation via MQTT discovery:

* Sensors
* Numbers
* Select entities
* Switches
* Binary sensors

No manual YAML required.

---

# 🔧 Compatibility

Compatible with most Voltronic protocol inverters:

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* Compatible clones

---

# 🛠 Support

Open a GitHub issue for:

* Bugs
* Compatibility reports
* Feature requests

---

# ❤️ Contributing

Open source project.

Contributions welcome:

* Testing
* Feedback
* Documentation
* Improvements

---

# 🚀 Roadmap

Planned improvements:

* Support for additional inverter brands
* Compatibility improvements
* Windows standalone version
* Advanced diagnostics
* Standalone GUI
* Premium expansion

---

# ⭐ If this project helps you

You can:

* Star the repository
* Share feedback
* Support development

---

# 🔋 Smart inverter control fully integrated into Home Assistant
