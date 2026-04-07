# Changelog – Smart Voltronic Add-on
---

## 🔄 1.7.1

### Improvements
- Improved timezone management for energy counters and daily resets.
- Better handling of local time detection between add-on configuration and runtime.
- Enhanced reliability of premium energy flow calculations.

### Fixes
- Fixed an issue where some daily counters could reset at the wrong time depending on timezone.
- Fixed timezone fallback behavior that could cause resets to happen on UTC instead of the configured timezone.
- Fixed a bug where grid contribution could be displayed as 0% even when grid energy was actually used.
- Fixed inconsistencies between grid counters and energy repartition percentages.

### Premium
- Improved persistence and accuracy of premium energy flow indicators.

## 🔄 v1.7.0

Premium update + fixes

Added new Premium energy indicators for self-sufficiency and grid dependency
Added several new Premium-only sensors to improve monitoring and dashboard experience
Improved Premium energy and diagnostic calculations
Refined Premium dashboard integration and overall presentation
Fixed various bugs and stability issues

## 🔄 v1.6.9
* Bug fixe

---

## 🔄 v1.6.4
* Bug fixe

---

## 🔄 v1.6.3
* Bug fixe

---

## 1.6.2

- Premium dashboard is now available in English
- New configuration option added to choose the dashboard language
- Users can now switch the Premium dashboard between French and English directly from the add-on configuration
  
---

## Version 1.6.1
Improved compatibility for grid charging current handling.
General reliability improvements for parameter setting on supported inverters.

---

1.6.0 – Automatic dashboard system and card management
⚠️ Breaking change – entity stabilization

Warning: some entities may have changed names in this version.

Entity IDs have been standardized and fixed to ensure stability between installations and to allow reliable automatic dashboard generation.

This change prevents entity renaming issues and ensures the Smart Voltronic dashboard can always be generated correctly.

After updating, Home Assistant may create some new entities. Old entities can be safely removed if no longer used.

Automatic dashboard system

Smart Voltronic can now automatically generate a complete Home Assistant dashboard when the addon starts.

The dashboard structure is now fully automated and requires no manual setup.

Custom card integration

If the following cards are installed:

mini-graph-card
apexcharts-card
card-mod

Smart Voltronic automatically builds an advanced visual dashboard using these cards.

This allows:

Advanced graphs
Better power monitoring visualization
Improved UI clarity
More modern interface
Automatic fallback mode

If custom cards are not installed:

Smart Voltronic automatically generates a dashboard using only native Home Assistant cards.

This ensures:

No broken dashboards
No missing Lovelace resources
No frontend errors
Immediate usability after installation
No manual user actions required

The dashboard remains fully functional with a simpler visual design.

New configuration option

New option added:

dashboard_custom_cards_installed

Allows the addon to know if custom cards are installed and generate the appropriate dashboard.

Goal of this update

Improve dashboard reliability and make Smart Voltronic closer to a true plug & play experience.

---

## Version 1.5.9

## ⭐ Premium features introduction

Version 1.5.9 introduces the **Premium system**, unlocking advanced monitoring features and additional calculated sensors for supported inverters.

Premium enables advanced analytics and automatic fallback calculations when the inverter does not provide some energy values.

---

## 🔋 New Premium energy sensors (fallback calculations)

For inverters that do not expose these values, Smart Voltronic can now calculate:

### Monthly energy:

* PV energy month
* Load energy month
* Grid energy month
* Battery charge energy month
* Battery discharge energy month

### Yearly energy:

* PV energy year
* Load energy year
* Grid energy year
* Battery charge energy year
* Battery discharge energy year

If the inverter already provides these values, native inverter values are always used instead of calculated ones.

---

## ❤️ Battery health indicator

A new **Battery Health** indicator has been added.

This value is estimated based on inverter data and daily operating behaviour.

⚠️ This value is provided for **informational purposes only** and should not be considered as an exact battery diagnostic.

---

## 🩺 Inverter health indicator

A new **Inverter Health** indicator is now available.

This score reflects general inverter operating conditions and behaviour.

⚠️ This value is also provided for **informational purposes only**.

---

## 📊 Daily energy distribution sensors

New daily distribution sensors:

* Solar contribution %
* Battery contribution %
* Grid contribution %

These sensors show how the load was supplied during the day.

---

## 🎨 Premium dashboard

Premium enables an advanced dashboard including:

* Visual energy distribution
* Power history graphs
* Battery and inverter health indicators
* Advanced diagnostics view

---

## ⚙️ Improvements

* Improved fallback energy calculations
* Better calculation stability
* Improved compatibility across inverter models

## Version 1.5.8

### Improvements
- Improved command compatibility across different inverter models
- Better handling of communication differences between inverter generations
- Increased reliability when sending control commands
- General communication stability improvements

### Fixes
- Fixed some commands not being accepted on certain older inverters
- Improved overall command execution consistency

## 🔄 v1.5.7
* Bug fixe

## Changelog v1.5.4

* Added new inverter control switches in Home Assistant:

  * Overload bypass
  * Fault auto restart
  * Over temperature restart

* Improved fault reporting for faster and more reliable status updates in Home Assistant

* Better synchronization between inverter settings and Home Assistant after configuration changes

* Enhanced diagnostic integration for advanced inverter protection settings


## 🔄 v1.5.3
* Bug fixe

## 1.5.2

### Added

* Automatic inverter command learning system to improve compatibility across different Voltronic firmware versions
* New compatibility modes (Modern / Legacy) to adapt behavior depending on inverter model
* Optional 2-choice source priority mode for inverters supporting only two priority options
* Automatic daily energy sensors when the inverter does not provide daily statistics

### Improved

* Better inverter compatibility handling
* Improved parameter synchronization reliability
* More consistent Home Assistant entity behavior
* Improved protection against unsupported settings

### Fixed

* Various compatibility issues with some inverter models
* Minor stability improvements

---

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

