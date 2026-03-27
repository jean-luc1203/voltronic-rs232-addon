# 🔋 Smart Voltronic – Add-on Home Assistant

Contrôlez et surveillez vos **onduleurs Voltronic / Axpert** directement depuis Home Assistant avec un système avancé d’apprentissage des commandes, des modes de compatibilité configurables et des fonctionnalités Premium optionnelles.

➡️ Documentation anglaise :  
https://github.com/jean-luc1203/voltronic-rs232-addon/blob/main/smart-voltronic/README.md

## ☕ Supporter le développement

Smart Voltronic est un projet open-source développé sur le temps libre.

Si vous le trouvez utile vous pouvez soutenir le développement et débloquer les fonctionnalités Premium :

<a href="https://ko-fi.com/tapion69">
<img src="https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/kofi-button.png" width="300">
</a>

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)
![Voltronic](https://img.shields.io/badge/Inverter-Voltronic-compatible-orange)
![MQTT](https://img.shields.io/badge/MQTT-Auto%20Discovery-green)
![Premium](https://img.shields.io/badge/Premium-Disponible-gold)

---

# 🚀 Nouveautés

## ⭐ Fonctionnalités Premium

Smart Voltronic Premium débloque des calculs avancés et des valeurs lorsque certaines données ne sont pas fournies par l’onduleur.

L’add-on reste entièrement fonctionnel sans Premium.

Premium permet :

* Capteurs PV mensuels et annuels en fallback (si l'onduleur ne les fournit pas)
* Capteurs Load mensuels et annuels en fallback
* Capteurs énergie batterie mensuels et annuels
* Indicateur de santé batterie
* Indicateur de santé onduleur
* Répartition journalière solaire / batterie / réseau en %
* Dashboard Premium avancé

---

# 🔑 Activation Premium

Premium est lié à votre **Install ID Home Assistant**.

## Étape 1 — Trouver votre Install ID

Aller dans :

**Paramètres → Appareils et services → MQTT**

Ouvrir :

**Smart Voltronic System**

Vous trouverez le **capteur Install ID**.

---

## Étape 2 — Acheter Premium

Acheter Premium via Ko-fi :

https://ko-fi.com/tapion69

Envoyer votre Install ID lors de l’achat.

---

## Étape 3 — Activer Premium

Ajouter votre clé dans la configuration de l’addon :

premium_key: YOUR_KEY_HERE

Redémarrer l’addon.

Premium s’active automatiquement.

---

# 📊 Logique Free vs Premium

Smart Voltronic utilise toujours **les valeurs natives de l’onduleur en priorité**.

Premium ne calcule que lorsque les données sont absentes.

---

## Énergie PV

PV journalier :  
✔ Free

PV mensuel :  
✔ Free si fourni par l'onduleur  
⭐ Premium fallback si absent

PV annuel :  
✔ Free si fourni par l'onduleur  
⭐ Premium fallback si absent

---

## Énergie Load

Load journalier :  
✔ Free

Load mensuel :  
✔ Free si fourni  
⭐ Premium fallback si absent

Load annuel :  
✔ Free si fourni  
⭐ Premium fallback si absent

---

## Énergie batterie

Charge / décharge journalière :  
✔ Free

Énergie batterie mensuelle :  
⭐ Premium uniquement

Énergie batterie annuelle :  
⭐ Premium uniquement

---

## Énergie réseau

Disponible uniquement si l’onduleur fournit les données grid.

Grid journalier :  
✔ Free si supporté

Grid mensuel :  
✔ Free si supporté  
⭐ Premium fallback si absent

Grid annuel :  
✔ Free si supporté  
⭐ Premium fallback si absent

Si l’onduleur ne fournit pas les données grid Smart Voltronic ne peut pas les estimer de manière fiable.

---

## ❤️ Indicateurs de santé

Premium ajoute :

* Score santé batterie
* Score santé onduleur

⚠️ Valeurs indicatives uniquement.

---

## 📊 Répartition énergétique journalière

Premium ajoute les pourcentages :

* Solaire %
* Batterie %
* Grid %

Permet de voir comment votre consommation a été alimentée.

---

# 🎨 Dashboard Premium

Premium active un dashboard avancé incluant :

* Graphiques de répartition énergie
* Vues mensuelles et annuelles
* Historique puissance
* Indicateurs de santé
* Diagnostics

Le dashboard est créé automatiquement si Premium est actif.

---

# 🧩 Système des cartes dashboard

Le dashboard Smart Voltronic peut fonctionner en **2 modes** selon les cartes installées.

## Mode Premium complet

Si ces cartes HACS sont installées :

* mini-graph-card
* apexcharts-card
* card-mod

Smart Voltronic utilisera automatiquement le dashboard visuel complet.

Installation :

HACS → Frontend :

mini-graph-card  
apexcharts-card  
card-mod  

Ensuite activer dans la configuration addon :

dashboard_custom_cards_installed: true

Redémarrer l’addon.

---

## Mode fallback natif

Si les cartes ne sont pas installées :

Smart Voltronic bascule automatiquement sur un dashboard **100% cartes natives Home Assistant**.

Cela garantit :

* Dashboard toujours fonctionnel
* Aucun resource cassé
* Aucun bug Lovelace
* Aucune manipulation utilisateur

L'affichage est simplement moins visuel.

Dans ce cas laisser :

dashboard_custom_cards_installed: false

---

## Pourquoi les cartes ne sont plus installées automatiquement

L'installation automatique HACS causait :

* erreurs frontend
* ressources manquantes
* cache HA bloqué
* installations incomplètes

L’installation manuelle est la méthode la plus fiable.

---

# 🧠 Apprentissage automatique des commandes

Smart Voltronic possède un moteur intelligent qui identifie automatiquement les commandes réellement supportées par votre onduleur.

Cela permet :

* meilleure compatibilité firmware
* éviter commandes invalides
* adapter automatiquement les réglages
* créer un profil compatibilité
* sécuriser les changements

Aucune action utilisateur nécessaire.

---

# 🧩 Modes de compatibilité

Les onduleurs Voltronic peuvent avoir des comportements différents selon firmware.

Smart Voltronic propose des modes configurables.

---

### Mode moderne

Recommandé pour firmware récents.

Fonctionnalités :

* Apprentissage commandes actif
* Adapté firmware récents
* Compatibilité améliorée
* Protection commandes invalides

---

### Mode legacy

Pour anciens firmware.

Fonctionnalités :

* Apprentissage commandes actif
* Adapté anciens modèles
* Compatibilité legacy
* Protection commandes invalides

---

### Mode priorité 2 choix

Certains onduleurs n'ont que 2 priorités au lieu de 3.

Ce mode permet :

* Adapter Home Assistant
* Eviter options invalides
* UI cohérente

Activer seulement si nécessaire.

---

# ⭐ Pourquoi Smart Voltronic est différent

Smart Voltronic ne fait pas qu’envoyer des commandes.

Il **s’adapte à votre onduleur**.

Avantages :

* meilleure compatibilité
* moins d’erreurs
* moins de configuration
* support multi firmware
* installation plus fiable

Objectif :

**Une intégration plug and play.**

---

# 📸 Screenshots

## Informations appareil

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

Deux modes sont supportés :

* **Connexion série directe en USB / RS232**
* **Connexion via gateway réseau TCP**

La connexion USB / RS232 reste la méthode recommandée pour la majorité des utilisateurs car elle est plus simple à mettre en place et généralement plus stable.

---

# 🔧 Tutoriel installation matériel

Cette section explique comment raccorder physiquement votre onduleur à Home Assistant avec les accessoires compatibles.

---

## 1) Câble de communication RJ45 côté onduleur

L’onduleur Voltronic utilise un câble de communication RJ45 spécifique pour la liaison série.

Ce câble se branche sur le port de communication de l’onduleur.

![Cable RJ45 inside](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-inside.jpg)

---

## 2) Adaptateur RJ45 vers DB9

Le câble RJ45 est généralement converti en DB9 grâce à un adaptateur RJ45 → DB9.

Cet adaptateur permet ensuite de relier l’onduleur à un convertisseur USB RS232 ou à une gateway série réseau.

![Cable RJ45 DB9](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9.jpg)

---

## 3) Schéma de brochage RJ45 / DB9

Si vous souhaitez vérifier votre câblage ou fabriquer votre propre câble, voici le pinout RJ45 / DB9.

⚠️ Vérifiez toujours le brochage avant branchement.  
Un mauvais câblage peut empêcher toute communication.

![Cable RJ45 DB9 Pinout](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/cable-rj45-db9-pinout.jpg)

---

## 4) Adaptateur USB vers RS232

Pour une connexion directe à Home Assistant, utilisez un adaptateur **USB → RS232**.

C’est la méthode la plus simple pour connecter l’onduleur en local.

Chipsets recommandés :

* FTDI
* Prolific PL2303

![USB RS232 Adapter](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/usb-rs232-adapter.png)

---

## 5) Gateway série réseau

Si votre onduleur est éloigné de votre serveur Home Assistant, vous pouvez utiliser une **gateway série → TCP**.

Modules couramment utilisés :

* Elfin EE10A
* Elfin EW10A

![Gateway](https://raw.githubusercontent.com/tapion69/smart-voltronic/main/smart-voltronic/docs/images/gateway.jpg)

---

# 🔌 Connexion série directe

La connexion directe RS232 est recommandée si votre onduleur est proche du système Home Assistant.

## Schéma de connexion

Onduleur  
↓  
Port de communication RJ45  
↓  
Câble RJ45 Voltronic  
↓  
Adaptateur RJ45 → DB9  
↓  
Adaptateur USB → RS232  
↓  
Home Assistant

## Avantages

* Installation simple
* Très bonne stabilité
* Pas de configuration réseau
* Détection facile du port série

## Vérifier le port série dans Home Assistant

Dans Home Assistant, le port série peut être retrouvé dans :

**Paramètres → Système → Matériel → Ports série**

Le port ressemble généralement à :

/dev/serial/by-id/usb-FTDI...  
ou  
/dev/ttyUSB0

---

# 🌐 Connexion gateway réseau

Cette méthode permet de faire passer la communication série de l’onduleur par le réseau local.

## Schéma de connexion

Onduleur  
↓  
Port RJ45 / RS232  
↓  
Câble de communication Voltronic  
↓  
Adaptateur RJ45 → DB9  
↓  
Gateway série réseau  
↓  
Réseau local  
↓  
Home Assistant

## Quand utiliser cette méthode

* Onduleur éloigné de Home Assistant
* Pas de possibilité de liaison USB directe
* Besoin d’une intégration via TCP

---

## Configuration recommandée de la gateway

### Paramètres série

2400 baud  
8 data bits  
1 stop bit  
No parity  

### Paramètres réseau

TCP Server  
Port 8899  

---

## Exemple de configuration côté addon

Pour une connexion série :

inv1_link: serial  
inv1_serial_port: /dev/serial/by-id/usb-FTDI...

Pour une connexion gateway :

inv1_link: gateway  
inv1_gateway_host: 192.168.1.40  
inv1_gateway_port: 8899

---

# ⚠️ Conseils importants avant branchement

* Utiliser de préférence un câble Voltronic d’origine ou un câble compatible vérifié
* Vérifier le bon pinout RJ45 / DB9
* Ne pas inverser un câble réseau standard avec un câble de communication série
* En cas de doute, tester d’abord en connexion USB directe
* Si la communication ne fonctionne pas, vérifier en priorité :
  * le port série
  * le câblage
  * le baudrate
  * l’adresse IP de la gateway
  * le port TCP configuré

---

# ⚙️ Configuration

Exemple :

inv1_link: serial  
inv1_serial_port: /dev/serial/by-id/...  

inv2_link: gateway  
inv2_gateway_host: 192.168.1.40  
inv2_gateway_port: 8899  

premium_key: YOUR_KEY_HERE  

MQTT :

voltronic/1/  
voltronic/2/  
voltronic/3/  

---

# ✨ Fonctionnalités

## Monitoring complet

Capteurs automatiques :

* Production PV
* Puissance batterie
* Consommation grid
* Charge
* Tensions
* Courants
* SOC batterie
* Température
* Alarmes
* Statut

Refresh :

≈ 4 secondes

---

## Contrôle onduleur

Paramètres :

* Priorité sortie
* Priorité charge
* Type batterie
* Tensions charge
* Limites courant
* Paramètres grid

Chaque changement est :

* Vérifié
* Confirmé
* Synchronisé

---

# 🏠 Intégration Home Assistant

Création automatique MQTT discovery :

* Sensors
* Numbers
* Select
* Switch
* Binary sensors

Aucun YAML manuel.

---

# 🔧 Compatibilité

Compatible protocol Voltronic :

* Axpert
* VM
* MKS
* MAX
* MAX II
* MAX IV
* Clones compatibles

---

# 🛠 Support

GitHub issues pour :

* Bugs
* Compatibilité
* Features

---

# ❤️ Contribution

Projet open source.

Contributions bienvenues :

* Tests
* Feedback
* Documentation
* Améliorations

---

# 🚀 Roadmap

Améliorations prévues :

* Support autres marques
* Compatibilité étendue
* Version Windows
* Diagnostics avancés
* GUI standalone
* Extensions Premium

---

# ⭐ Si ce projet vous aide

Vous pouvez :

* Star le repo
* Donner feedback
* Supporter le développement

---

# 🔋 Contrôle intelligent des onduleurs directement dans Home Assistant
