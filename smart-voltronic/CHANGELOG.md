# Changelog – Smart Voltronic Add-on

## 1.5.1

### Improvements

* Added **display mode selection (Modern / Legacy)** in the add-on configuration.
* **Modern mode** keeps the standard Home Assistant naming for inverter priorities.
* **Legacy mode** restores the classic inverter terminology (USB / SUB / SBU and CSO / SNU / OSO) for users familiar with the original inverter display.
* Improved compatibility with different Voltronic inverter firmware versions.

### Enhancements

* The add-on now **automatically detects unsupported inverter commands**.
* Commands that are not supported by the inverter will **automatically disable themselves** to prevent repeated errors and unnecessary polling.

### Fixes

* Minor stability improvements.
* Various small fixes and internal optimizations.


## 1.4.9

### Added
- Added support for **24V battery systems**
- New add-on configuration option to select **battery system voltage (24V / 48V)**

### Improved
- Home Assistant voltage parameter ranges now automatically adapt to the selected battery system
  - **24V systems**
    - Bulk: 24–30V
    - Float: 24–30V
    - Return grid voltage: 22–25.5V
    - Re-discharge voltage: 24–29V
    - Under voltage: 20–27V
  - **48V systems**
    - Existing ranges remain unchanged

### Technical
- MQTT Discovery updated to dynamically adjust voltage parameter limits based on battery system voltage
- Added internal configuration handling for battery system detection

## 🔄 v1.4.8
* Bug fixe

## 🔄 v1.4.7

### ✨ New

* Added support for **Elfin Ethernet/WiFi gateways**
* Inverters can now be connected using either **Serial (USB/RS232)** or **Gateway (TCP/IP)**
* New configuration options for each inverter:

  * `serial` connection
  * `gateway` connection (IP + port)

### ⚙️ Improvements

* Automatic TCP configuration for Elfin gateways
* Dynamic transport selection (Serial or TCP) directly from add-on configuration
* Improved startup script to apply network settings automatically
* Better connection handling when switching between Serial and Gateway modes

### 🛠 Internal

* Refactored startup script to dynamically patch TCP nodes
* Improved connection logic to prevent conflicts between Serial and TCP transports


## 🔄 Version 1.4.6
* Bug fixe

## 🔄 Version 1.4.5

### 🌍 Added Timezone Support

* New configurable timezone option in add-on settings
* Dropdown selection for common timezones
* Custom timezone support (IANA format, e.g. `Europe/Athens`)
* Used for accurate daily energy reset calculations
* Fully handled inside the add-on (no Home Assistant configuration required)

### ⚡ New Sensor: Grid Energy Today

* Added `grid_today` energy sensor
* Automatically calculated from `grid_power`
* Daily reset based on configured timezone
* Exposed via MQTT discovery
* Works on all supported inverter models

### 🌐 Translations

* Added English and French translations
* Improved configuration UI labels

### 🛠 Improvements

* Safe timezone handling in run.sh
* Robust daily energy reset logic
* No breaking changes

---

## v1.4.3

### ✨ New features
- MQTT Discovery is now **dynamic based on configured inverters**.
- Entities are created **only for configured serial ports**.
- Prevents Home Assistant from creating unused inverter devices.

### ⚙️ Improvements
- Refactored MQTT Discovery code to a **generic multi-inverter architecture**.
- Removed duplicated discovery logic for inverter 1/2/3.
- Easier maintenance and future feature additions.

### 🚀 Reliability
- Prevents ghost devices and unused entities when only one inverter is connected.
- Ensures Home Assistant device list always matches the real hardware configuration.

## v1.4.2

### ✨ New features
- Added new **Inverter Output Current** sensor (A).
- This sensor estimates the AC output current using inverter power and voltage.

### ℹ️ Notes
- The inverter does **not provide this value directly**.
- The current is **calculated by the add-on** using real-time measurements (Power ÷ Voltage).

## v1.4.1

### 🐞 Fixes
- Fixed sensors resetting to `0` or `unknown` after Home Assistant or add-on restart.
- MQTT state topic is now published with **retain enabled**.

### 🚀 Improvements
- Home Assistant now restores the **last known inverter values instantly** after restart.
- Improved overall reliability and startup behavior.

## v1.4.0

### ✨ New features
- Added new **Global Battery Current** sensor (A).
- The sensor provides a **signed current value**:
  - Positive → battery charging  
  - Negative → battery discharging
- Automatically created via MQTT Discovery (no Home Assistant setup required).

### ⚙️ Improvements
- Improved battery monitoring with clearer charge/discharge visibility.

## v1.3.9

### ✨ New features
- Added **daily battery energy sensors**:
  - Battery charge today (kWh)
  - Battery discharge today (kWh)
- These sensors are now **automatically created** by the add-on (no Home Assistant configuration required).

### ℹ️ Notes
- Daily battery energy values are **calculated by the add-on** from real-time power measurements.
- These values are **not provided directly by the inverter**.
- Automatic reset at midnight (local time).

## v1.3.8

### 🐞 Fixes
- Fixed incorrect handling of **Max Discharging Current** parameter.

### ⚙️ Improvements
- Added **better error handling and logging** to reduce Home Assistant log spam.
- Improved MQTT payload sanitization and command normalization.
- Ensured **inverter parameters (QPIRI / QDOP / diagnostics)** are fetched immediately at startup.

### 🚀 Reliability
- More robust startup sequence to guarantee parameters and diagnostics are available right after boot.

## v1.3.7 – Initial release

🎉 First functional release of the add-on.

### Added

* Add-on is now **operational**
* Serial communication with Voltronic inverters
* MQTT data publishing
* Home Assistant integration (auto-discovery)
* Foundation for multi-inverter support

