# 🔋 Smart Voltronic – Home Assistant Add-on

Control and monitor your **Voltronic / Axpert inverters** directly from Home Assistant with an advanced command learning system, configurable compatibility modes and optional Premium features.

➡️ French documentation:  
https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README_FR.md

## ☕ Support development

Smart Voltronic is an open-source project developed during free time.

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

## ⭐ Premium Features

Smart Voltronic Premium unlocks advanced calculations and values when some data is not provided by the inverter.

The add-on remains fully functional without Premium.

Premium provides:

* Monthly and yearly PV energy fallback sensors
* Monthly and yearly Load energy fallback sensors
* Monthly and yearly battery energy sensors
* Battery health indicator
* Inverter health indicator
* Daily solar / battery / grid energy distribution %
* Advanced Premium dashboard

---

# 🔑 Premium activation

Premium is linked to your **Home Assistant Install ID**.

## Step 1 — Find your Install ID

Go to:

**Settings → Devices & Services → MQTT**

Open:

**Smart Voltronic System**

You will find the **Install ID sensor**.

---

## Step 2 — Buy Premium

Purchase Premium via Ko-fi:

https://ko-fi.com/tapion69

Send your Install ID when purchasing.

---

## Step 3 — Activate Premium

Add your key in the addon configuration:

premium_key: YOUR_KEY_HERE

Restart the addon.

Premium activates automatically.

---

# 📊 Free vs Premium logic

Smart Voltronic always uses **native inverter values first**.

Premium only calculates values when data is missing.

---

## PV Energy

Daily PV:  
✔ Free

Monthly PV:  
✔ Free if inverter provides it  
⭐ Premium fallback if missing

Yearly PV:  
✔ Free if inverter provides it  
⭐ Premium fallback if missing

---

## Load Energy

Daily Load:  
✔ Free

Monthly Load:  
✔ Free if provided  
⭐ Premium fallback if missing

Yearly Load:  
✔ Free if provided  
⭐ Premium fallback if missing

---

## Battery Energy

Daily charge/discharge:  
✔ Free

Monthly battery energy:  
⭐ Premium only

Yearly battery energy:  
⭐ Premium only

---

## Grid Energy

Available only if inverter provides grid data.

Daily grid:  
✔ Free if supported

Monthly grid:  
✔ Free if supported  
⭐ Premium fallback if missing

Yearly grid:  
✔ Free if supported  
⭐ Premium fallback if missing

If the inverter does not provide grid data Smart Voltronic cannot estimate it reliably.

---

## ❤️ Health indicators

Premium adds:

* Battery health score
* Inverter health score

⚠️ Informational values only.

---

## 📊 Daily energy distribution

Premium adds percentages:

* Solar %
* Battery %
* Grid %

Shows how your consumption was powered.

---

# 🎨 Premium dashboard

Premium automatically enables an advanced dashboard including:

* Energy distribution graphs
* Monthly and yearly views
* Power history
* Health indicators
* Diagnostics

---

# 🧩 Dashboard card system

Smart Voltronic dashboard works in **2 modes** depending on installed cards.

## Full Premium mode

If these HACS cards are installed:

* mini-graph-card
* apexcharts-card
* card-mod

Smart Voltronic automatically enables the full visual dashboard.

Installation:

HACS → Frontend:

mini-graph-card  
apexcharts-card  
card-mod  

Then enable in addon config:

dashboard_custom_cards_installed: true

Restart addon.

---

## Native fallback mode

If cards are not installed:

Smart Voltronic automatically switches to a **100% native Home Assistant dashboard**.

This guarantees:

* Always working dashboard
* No broken resources
* No Lovelace errors
* No manual user work

Display is simply less visual.

Leave:

dashboard_custom_cards_installed: false

---

## Why cards are not auto installed anymore

Automatic HACS installation caused:

* frontend errors
* missing resources
* HA cache issues
* incomplete installs

Manual install is more reliable.

---

# 🧠 Automatic command learning

Smart Voltronic includes an intelligent engine that detects which commands are truly supported.

This allows:

* better firmware compatibility
* avoid invalid commands
* automatic adaptation
* compatibility profile creation
* safe parameter changes

No user action required.

---

# 🧩 Compatibility modes

Voltronic inverters behave differently depending on firmware.

Smart Voltronic provides configurable modes.

---

### Modern mode

Recommended for recent firmware:

* command learning active
* improved compatibility
* command protection

---

### Legacy mode

For older firmware:

* command learning active
* legacy compatibility

---

### 2 choice priority mode

Some inverters only support 2 priorities.

This mode:

* adapts Home Assistant UI
* avoids invalid options
* keeps UI clean

Enable only if needed.

---

# ⭐ Why Smart Voltronic is different

Smart Voltronic does not just send commands.

It **adapts to your inverter**.

Advantages:

* better compatibility
* fewer errors
* less configuration
* multi firmware support
* more reliable installation

Goal:

**True plug and play integration.**

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

Two supported methods:

* Direct USB RS232 connection
* Network TCP gateway connection

USB RS232 is recommended for most users.

---

# 🔧 Hardware installation guide

This section explains how to physically connect your inverter.

---

## 1) RJ45 communication cable

Voltronic inverters use a dedicated RJ45 communication cable.

![Cable](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-inside.jpg)

---

## 2) RJ45 to DB9 adapter

Used to convert RJ45 to RS232 DB9.

![DB9](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9.jpg)

---

## 3) RJ45 DB9 pinout

Useful if making your own cable.

![Pinout](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9-pinout.jpg)

---

## 4) USB RS232 adapter

Used for direct Home Assistant connection.

Recommended chipsets:

* FTDI
* PL2303

![USB](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/usb-rs232-adapter.png)

---

## 5) Network gateway

Used if inverter is far from Home Assistant.

Supported:

* Elfin EE10A
* Elfin EW10A

![Gateway](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/gateway.jpg)

---

# 🔌 Direct RS232 connection

Recommended if inverter is close.

Connection:

Inverter  
↓  
RJ45 cable  
↓  
RJ45 DB9 adapter  
↓  
USB RS232  
↓  
Home Assistant

Advantages:

* simple install
* very stable
* no network config
* easy detection

Find serial port:

**Settings → System → Hardware**

Example:

/dev/serial/by-id/usb-FTDI...

---

# 🌐 Network gateway connection

Used for TCP communication.

Connection:

Inverter  
↓  
RJ45 / RS232  
↓  
Gateway  
↓  
Network  
↓  
Home Assistant

---

## Gateway configuration

Serial:

2400 baud  
8 data bits  
1 stop bit  
No parity  

Network:

TCP Server  
Port 8899  

---

# ⚠️ Important tips

* Use original Voltronic cable when possible
* Verify RJ45 pinout
* Do not confuse with ethernet cable
* Test USB first if unsure
* Check:

serial port  
wiring  
baudrate  
gateway IP  
TCP port  

---

# ⚙️ Configuration

Example:

inv1_link: serial  
inv1_serial_port: /dev/serial/by-id/...  

inv2_link: gateway  
inv2_gateway_host: 192.168.1.40  
inv2_gateway_port: 8899  

premium_key: YOUR_KEY_HERE  

MQTT:

voltronic/1/  
voltronic/2/  
voltronic/3/

---

# ✨ Features

## Monitoring

Sensors:

* PV production
* Battery power
* Grid consumption
* Load
* Voltage
* Current
* SOC
* Temperature
* Alarms
* Status

Refresh:

≈ 4 seconds

---

## Inverter control

Parameters:

* output priority
* charger priority
* battery type
* charge voltages
* current limits
* grid settings

Each change is:

* verified
* confirmed
* synchronized

---

# 🏠 Home Assistant integration

Automatic MQTT discovery:

* Sensors
* Numbers
* Select
* Switch
* Binary sensors

No YAML needed.

---

# 🔧 Compatibility

Voltronic protocol:

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* Compatible clones

---

# 🛠 Support

GitHub issues for:

* Bugs
* Compatibility
* Features

---

# ❤️ Contribution

Open source project.

Contributions welcome:

* Testing
* Feedback
* Documentation
* Improvements

---

# 🚀 Roadmap

Planned:

* Other inverter brands
* Windows version
* Standalone GUI
* Advanced diagnostics
* Premium extensions

---

# ⭐ If this project helps you

You can:

* Star the repo
* Give feedback
* Support development

---

# 🔋 Smart inverter control directly inside Home Assistant
