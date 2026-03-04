# 🔋 Smart Voltronic – Home Assistant Add-on

➡️ **Lire ce README en français :**
https://github.com/tapion69/smart-voltronic/blob/main/smart-voltronic/README_FR.md

☕ **Support the project**

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>


![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)

Home Assistant add-on designed to **monitor and control up to 3 Voltronic / Axpert inverters**.

Compatible with most models using the **Voltronic protocol**:

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* and compatible clones

---

# 📑 Table of Contents

* Screenshots
* Connection Methods
* Serial Installation
* Gateway Installation
* Configuration
* Features
* Home Assistant Integration
* Telemetry
* Support

---

# 📸 Screenshots

### 🔎 Device information & status

Monitor inverter status, firmware, warnings and fault details directly in Home Assistant.

![Device info](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/dashboard-overview.png)

---

### ⚙️ Inverter settings from Home Assistant

Change key inverter parameters directly from Home Assistant UI:

* battery type
* charging priority
* voltages
* grid settings

![Settings](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-settings.png)

---

### ⚡ Real-time power monitoring

Track all electrical values in real time:

* AC output
* battery charge/discharge
* grid usage
* load statistics

![Power](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-power.png)

---

### ☀️ Solar production tracking

Monitor PV production and MPPT inputs.

![PV](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-pv.png)

---

# 🔌 Connection Methods

The inverter can be connected to Home Assistant in **two ways**:

1️⃣ **Serial (USB / RS232)**
2️⃣ **Gateway (Ethernet / Wi-Fi)**

Up to **3 inverters can be managed simultaneously**.

---

# 🔧 Serial Installation (RS232)

The inverter communicates via **RS232 through an RJ45 connector**.

Connection chain:

```
Inverter RJ45
     ↓
RJ45 → DB9 cable
     ↓
USB → RS232 adapter
     ↓
Home Assistant
```

---

## RJ45 → DB9 wiring

![RJ45 to DB9 pinout](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9-pinout.jpg)

### Wiring table

| RJ45 | DB9 | Signal |
| ---- | --- | ------ |
| 1    | 2   | TX     |
| 2    | 3   | RX     |
| 8    | 5   | GND    |

⚠️ Important

* RJ45 diagram = **Top view**
* DB9 diagram = **Front view**

---

## Example finished cable

![RJ45 DB9 cable](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9.jpg)

Inside the RJ45 connector only **3 wires are used**.

![RJ45 wiring](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-inside.jpg)

---

## USB → RS232 adapter

Recommended chipsets:

* ⭐ **FTDI**
* ✔ **Prolific PL2303**

![USB RS232 adapter](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/usb-rs232-adapter.png)

---

# 🌐 Gateway Installation (Ethernet / Wi-Fi)

The add-on also supports **serial gateway modules**, allowing communication over the network instead of USB.

Useful when:

* Home Assistant is far from the inverter
* You prefer **network communication**
* USB is not available

---

## Recommended gateway modules

The following **Elfin gateways are recommended and fully tested**:

* **Elfin EE10A** – Ethernet version
* **Elfin EW10A** – Wi-Fi version

![Elfin Gateway](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/gateway.jpg)

These modules convert **RS232 → TCP/IP**.

---

## Gateway connection diagram

```
Inverter RJ45
      ↓
RJ45 → RS232 cable
      ↓
Elfin gateway
      ↓
Ethernet / WiFi network
      ↓
Home Assistant
```

---

## Gateway configuration

Serial settings:

```
Baudrate : 2400
Data bits : 8
Stop bits : 1
Parity : None
```

Network settings:

```
Mode : TCP Server
Port : 8899
```

---

# ⚙️ Add-on Configuration

Each inverter can be configured independently.

Example:

```yaml
inv1_link: serial
inv1_serial_port: /dev/serial/by-id/...

inv2_link: gateway
inv2_gateway_host: 192.168.1.40
inv2_gateway_port: 8899
```

MQTT topics are separated per inverter:

```
voltronic/1/...
voltronic/2/...
voltronic/3/...
```

---

# ✨ Main Features

### 🟢 Full monitoring

Automatic sensors:

* PV power
* battery power
* grid consumption
* load power
* voltages
* currents
* temperatures
* alarms

Refresh rate ≈ **4 seconds**

---

### 🎛️ Control from Home Assistant

Modify inverter parameters:

* Output priority
* Charging priority
* Battery type
* Voltage settings
* Current limits

Changes are automatically verified and synchronized.

---

# 🏠 Home Assistant Integration

Entities are automatically created using **MQTT Auto-Discovery**.

Types created:

* sensors
* numbers
* selects
* switches
* binary sensors

No YAML required.

---

# 🔐 Robust & Reliable

Features include:

* command queue system
* automatic NAK handling
* communication error recovery
* inverter compatibility detection

---

# 📊 Anonymous telemetry (optional)

To help understand how many installations run the add-on, an optional telemetry ping is available.

The add-on sends a small daily **“bip”** request.

Privacy guaranteed:

* No IP stored
* No inverter data
* No Home Assistant data

Disable telemetry:

```yaml
send_bip: false
```

---

# 📄 Full parameter list

https://github.com/tapion69/smart-voltronic/blob/main/smart-voltronic/PARAMETERS.md

---

# 🛠 Support

Open an **issue on GitHub** for bug reports or feature requests.

---

# ❤️ Contribution

Open-source project.
Contributions and feedback are welcome.

---

**Smart inverter control fully integrated into Home Assistant 🚀**
