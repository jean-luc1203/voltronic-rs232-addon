# 🔋 Smart Voltronic – Add-on Home Assistant

Pilotez et surveillez vos onduleurs **Voltronic / Axpert** directement depuis Home Assistant avec un système avancé d’apprentissage des commandes et des modes de compatibilité configurables.

➡️ Documentation française :  
https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README_FR.md

## ☕ Soutenir le développement

Smart Voltronic est un projet open-source développé sur le temps libre.

Si ce projet vous est utile, vous pouvez soutenir son développement :

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-compatible-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)

---

# 🚀 Nouveautés

## 🧠 Apprentissage automatique des commandes onduleur

Smart Voltronic intègre un moteur permettant d’identifier automatiquement les commandes réellement supportées par votre onduleur.

Cela permet :

* D’améliorer la compatibilité entre firmwares Voltronic
* D’éviter l’envoi de commandes non supportées
* D’adapter automatiquement les paramètres disponibles
* De construire un profil de compatibilité
* De sécuriser les modifications envoyées

Aucune action utilisateur nécessaire.

---

## 🧩 Modes de compatibilité configurables

Smart Voltronic propose plusieurs modes permettant d’adapter le fonctionnement selon le comportement de votre onduleur.

Ces modes sont configurables dans l’add-on.

### Mode Modern

Mode recommandé pour les firmwares récents ou les modèles récents.

Fonctionnalités :

* Utilise le système d’apprentissage des commandes
* Fonctionnement adapté aux comportements récents
* Compatibilité améliorée avec les firmwares modernes
* Protection contre les commandes invalides

---

### Mode Legacy

Mode recommandé pour les anciens firmwares ou les modèles plus anciens.

Fonctionnalités :

* Utilise également le système d’apprentissage des commandes
* Fonctionnement adapté aux comportements plus anciens
* Compatibilité renforcée avec certains modèles legacy
* Protection contre les commandes invalides

---

### Mode priorité source 2 choix

Certains onduleurs ne supportent que 2 modes de priorité source au lieu de 3.

Ce mode permet :

* D’adapter les options affichées dans Home Assistant
* D’éviter les commandes non supportées
* D’améliorer la cohérence entre l’interface et l’onduleur

À activer uniquement si votre modèle fonctionne avec 2 choix.

---

# ⭐ Pourquoi Smart Voltronic est différent

Smart Voltronic ne se contente pas d’envoyer des commandes.

Il adapte son fonctionnement à votre onduleur.

Avantages :

* Meilleure compatibilité
* Moins d’erreurs
* Configuration simplifiée
* Support de nombreux firmwares
* Installation plus fiable

Objectif :

**Rendre l’intégration la plus plug and play possible.**

---

# 📸 Captures

## Informations onduleur

![Device](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/dashboard-overview.png)

---

## Paramètres

![Settings](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-settings.png)

---

## Monitoring puissance

![Power](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-power.png)

---

## Production solaire

![PV](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/inverter-pv.png)

---

# 🔌 Méthodes de connexion

Deux types de connexion sont supportés.

## Connexion série

Connexion directe via RS232.

```
Onduleur RJ45
↓
Câble RJ45 → DB9
↓
Adaptateur USB RS232
↓
Home Assistant
```

Chipsets recommandés :

* FTDI
* Prolific PL2303

---

## Connexion gateway réseau

Permet une communication via le réseau.

Modules supportés :

* Elfin EE10A
* Elfin EW10A

Connexion :

```
Onduleur
↓
RS232
↓
Gateway
↓
Réseau
↓
Home Assistant
```

Configuration gateway :

Serial :

```
2400 baud
8 bits
1 stop
Pas de parité
```

Network :

```
TCP Server
Port 8899
```

---

# ⚙️ Configuration

Exemple :

```yaml
inv1_link: serial
inv1_serial_port: /dev/serial/by-id/...

inv2_link: gateway
inv2_gateway_host: 192.168.1.40
inv2_gateway_port: 8899

# Modes de compatibilité
inverter_mode: modern

# modern ou legacy

source_priority_mode: 3

# 3 = USB / SUB / SBU
# 2 = SUB / SBU uniquement
```

MQTT :

```
voltronic/1/
voltronic/2/
voltronic/3/
```

---

# ✨ Fonctionnalités

## Monitoring complet

Capteurs automatiques :

* Production PV
* Puissance batterie
* Consommation réseau
* Charge
* Tensions
* Courants
* SOC batterie
* Température
* Alarmes
* Statut

Rafraîchissement :

≈ 4 secondes

---

## Contrôle onduleur

Paramètres modifiables :

* Priorité source
* Priorité charge
* Type batterie
* Tensions charge
* Limites courant
* Paramètres réseau

Chaque modification est :

* Vérifiée
* Confirmée
* Synchronisée

---

# 🏠 Intégration Home Assistant

Création automatique via MQTT Discovery :

* Sensors
* Numbers
* Select
* Switch
* Binary sensors

Aucun YAML manuel nécessaire.

---

# 📊 Télémétrie optionnelle

Permet d’estimer le nombre d’installations.

Envoie :

Une requête minimale quotidienne.

Ne collecte jamais :

* Données personnelles
* IP
* Données onduleur
* Données Home Assistant

Désactivation :

```yaml
send_bip: false
```

---

# 🔧 Compatibilité

Compatible avec la majorité des onduleurs Voltronic :

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* Clones compatibles

Grâce au système d’apprentissage des commandes et aux modes de compatibilité configurables.

---

# 🛠 Support

Créer une issue GitHub pour :

* Bugs
* Compatibilité modèles
* Demandes fonctionnalités

---

# ❤️ Contribution

Projet open-source.

Contributions bienvenues :

* Tests
* Feedback
* Documentation
* Code

---

# 🚀 Roadmap

Prévu :

* Support nouveaux modèles
* Amélioration compatibilité
* Version Windows standalone
* Diagnostics avancés
* Interface graphique standalone

---

# ⭐ Si ce projet vous aide

Vous pouvez :

* Mettre une étoile GitHub
* Partager votre retour
* Supporter le projet

---

# 🔋 Smart inverter control fully integrated into Home Assistant
