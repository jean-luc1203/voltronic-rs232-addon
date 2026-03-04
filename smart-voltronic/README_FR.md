# 🔋 Smart Voltronic – Module complémentaire Home Assistant

➡️ **Read this README in English :**
https://github.com/tapion69/smart-voltronic/blob/main/smart-voltronic/README.md

☕ **Soutenir le projet**

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)

Module complémentaire Home Assistant permettant de **surveiller et contrôler jusqu’à 3 onduleurs Voltronic / Axpert**.

Compatible avec la majorité des modèles utilisant le **protocole Voltronic** :

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* et clones compatibles

---

# 📑 Table des matières

* Captures d’écran
* Méthodes de connexion
* Installation série
* Installation via passerelle
* Configuration
* Fonctionnalités
* Intégration Home Assistant
* Télémétrie
* Support

---

# 📸 Captures d’écran

### 🔎 Informations et état de l’onduleur

Surveillez l’état de l’onduleur, le firmware, les avertissements et les défauts directement dans Home Assistant.

![Device info](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/dashboard-overview.png)

---

### ⚙️ Paramètres de l’onduleur depuis Home Assistant

Modifiez les principaux paramètres de l’onduleur directement depuis l’interface Home Assistant :

* type de batterie
* priorité de charge
* tensions
* paramètres réseau

![Settings](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-settings.png)

---

### ⚡ Surveillance de la puissance en temps réel

Suivez toutes les valeurs électriques en temps réel :

* sortie AC
* charge/décharge batterie
* utilisation du réseau
* statistiques de charge

![Power](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-power.png)

---

### ☀️ Suivi de la production solaire

Surveillez la production PV et les entrées MPPT.

![PV](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-pv.png)

---

# 🔌 Méthodes de connexion

L’onduleur peut être connecté à Home Assistant de **deux façons** :

1️⃣ **Connexion série (USB / RS232)**
2️⃣ **Connexion via passerelle réseau (Ethernet / Wi-Fi)**

Jusqu’à **3 onduleurs peuvent être gérés simultanément**.

---

# 🔧 Installation série (RS232)

L’onduleur communique via **RS232 à travers un connecteur RJ45**.

Chaîne de connexion :

```
Onduleur RJ45
     ↓
Câble RJ45 → DB9
     ↓
Adaptateur USB → RS232
     ↓
Home Assistant
```

---

## Câblage RJ45 → DB9

![RJ45 to DB9 pinout](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9-pinout.jpg)

### Tableau de câblage

| RJ45 | DB9 | Signal |
| ---- | --- | ------ |
| 1    | 2   | TX     |
| 2    | 3   | RX     |
| 8    | 5   | GND    |

⚠️ Important

* Schéma RJ45 = **vue de dessus**
* Schéma DB9 = **vue de face**

---

## Exemple de câble terminé

![RJ45 DB9 cable](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9.jpg)

À l’intérieur du connecteur RJ45 seuls **3 fils sont utilisés**.

![RJ45 wiring](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-inside.jpg)

---

## Adaptateur USB → RS232

Chipsets recommandés :

* ⭐ **FTDI**
* ✔ **Prolific PL2303**

![USB RS232 adapter](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/usb-rs232-adapter.png)

---

# 🌐 Installation via passerelle (Ethernet / Wi-Fi)

Le module complémentaire prend également en charge les **passerelles série**, permettant de communiquer avec l’onduleur **via le réseau au lieu de l’USB**.

Utile lorsque :

* Home Assistant est éloigné de l’onduleur
* vous préférez une **connexion réseau**
* l’USB n’est pas disponible

---

## Passerelles recommandées

Les passerelles **Elfin suivantes sont recommandées et testées** :

* **Elfin EE10A** – version Ethernet
* **Elfin EW10A** – version Wi-Fi

![Elfin Gateway](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/gateway.jpg)

Ces modules convertissent **RS232 → TCP/IP**.

---

## Schéma de connexion via passerelle

```
Onduleur RJ45
      ↓
Câble RJ45 → RS232
      ↓
Passerelle Elfin
      ↓
Réseau Ethernet / Wi-Fi
      ↓
Home Assistant
```

---

## Configuration de la passerelle

Paramètres série :

```
Baudrate : 2400
Data bits : 8
Stop bits : 1
Parity : None
```

Paramètres réseau :

```
Mode : TCP Server
Port : 8899
```

---

# ⚙️ Configuration du module

Chaque onduleur peut être configuré indépendamment.

Exemple :

```yaml
inv1_link: serial
inv1_serial_port: /dev/serial/by-id/...

inv2_link: gateway
inv2_gateway_host: 192.168.1.40
inv2_gateway_port: 8899
```

Les topics MQTT sont séparés pour chaque onduleur :

```
voltronic/1/...
voltronic/2/...
voltronic/3/...
```

---

# ✨ Fonctionnalités principales

### 🟢 Surveillance complète

Capteurs automatiques :

* puissance PV
* puissance batterie
* consommation réseau
* puissance de charge
* tensions
* courants
* températures
* alarmes

Fréquence de rafraîchissement ≈ **4 secondes**

---

### 🎛️ Contrôle depuis Home Assistant

Modification des paramètres de l’onduleur :

* priorité de sortie
* priorité de charge
* type de batterie
* tensions
* limites de courant

Chaque modification est :

1️⃣ envoyée à l’onduleur
2️⃣ relue automatiquement
3️⃣ synchronisée avec Home Assistant

---

# 🏠 Intégration Home Assistant

Les entités sont créées automatiquement via **MQTT Auto-Discovery**.

Types d’entités créées :

* capteurs
* nombres
* sélecteurs
* interrupteurs
* capteurs binaires

Aucune configuration YAML requise.

---

# 🔐 Robuste et fiable

Fonctionnalités incluses :

* système de file d’attente des commandes
* gestion automatique des NAK
* récupération après erreur de communication
* détection de compatibilité des onduleurs

---

# 📊 Télémétrie anonyme (optionnelle)

Afin d’estimer le nombre d’installations utilisant le module, une télémétrie optionnelle est disponible.

Le module envoie une petite requête **“bip” quotidienne**.

Respect de la vie privée :

* aucune adresse IP enregistrée
* aucune donnée onduleur
* aucune donnée Home Assistant

Désactiver la télémétrie :

```yaml
send_bip: false
```

---

# 📄 Liste complète des paramètres

https://github.com/tapion69/smart-voltronic/blob/main/smart-voltronic/PARAMETERS.md

---

# 🛠 Support

Ouvrez une **issue sur GitHub** pour signaler un bug ou proposer une amélioration.

---

# ❤️ Contribution

Projet open-source.

Les contributions et retours sont les bienvenus.

---

**Contrôle intelligent des onduleurs entièrement intégré à Home Assistant 🚀**

