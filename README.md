# 🤖 AVO — Compagnon Robotique Intelligent

AVO est un petit compagnon robotique personnel propulsé par l'intelligence artificielle. Il est conçu pour interagir naturellement avec son environnement et ses utilisateurs grâce à une combinaison de perception sensorielle, de traitement IA embarqué et d'expression physique.

---

## ✨ Vision du Projet

AVO a pour ambition d'être un compagnon de vie discret, expressif et utile. Capable de reconnaître voix, visages et contextes, il répond, apprend et s'adapte à son environnement de façon autonome tout en restant contrôlable et personnalisable.

---

## 🎯 Fonctionnalités Cibles

- 🎤 **Reconnaissance vocale** — comprendre et interpréter les commandes parlées
- 🗣️ **Synthèse vocale** — répondre oralement avec une voix naturelle
- 👁️ **Vision par ordinateur** — détecter visages, objets et gestes
- 🧠 **Module IA embarqué** — traitement local via modèle léger (ex. Ollama, TinyLLM)
- 🚗 **Locomotion** — déplacement autonome avec évitement d'obstacles
- 😊 **Expressivité** — affichage d'émotions via écran OLED ou LED
- 📡 **Connectivité** — communication Wi-Fi/Bluetooth, API distante optionnelle

---

## 🏗️ Architecture du Projet

```
avo/
├── firmware/          # Code embarqué (microcontrôleur, moteurs, capteurs)
├── ai/                # Modules d'intelligence artificielle
│   ├── speech/        # Reconnaissance et synthèse vocale
│   ├── vision/        # Traitement d'images et détection
│   └── llm/           # Intégration du modèle de langage
├── hardware/          # Schémas, plans 3D, liste de composants (BOM)
├── interface/         # Interface de contrôle (web, mobile ou CLI)
├── docs/              # Documentation technique et guides
└── tests/             # Tests unitaires et d'intégration
```

---

## 🔧 Stack Technique Envisagée

| Composant | Technologie |
|-----------|------------|
| Cerveau principal | Raspberry Pi 4 / 5 ou Jetson Nano |
| Microcontrôleur | Arduino / ESP32 |
| IA vocale | Whisper (OpenAI) + Piper TTS |
| Vision | OpenCV + MediaPipe |
| LLM local | Ollama (Llama 3 / Mistral) |
| Langage principal | Python 3.11+ |
| Communication interne | MQTT / Serial |
| Interface web | FastAPI + React (optionnel) |

---

## 🚀 Démarrage Rapide

### Prérequis

- Python 3.11+
- Raspberry Pi OS (ou Ubuntu 22.04+)
- Connexion au réseau local

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/hmzoo/avo.git
cd avo

# Créer un environnement virtuel
python -m venv .venv
source .venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt

# Lancer AVO
python main.py
```

---

## 🗺️ Feuille de Route

### Phase 1 — Fondations
- [x] Création du dépôt GitHub
- [ ] Définition de l'architecture matérielle
- [ ] Prototypage de la locomotion (châssis + moteurs)
- [ ] Mise en place de la communication série (Pi ↔ Arduino)

### Phase 2 — Intelligence
- [ ] Intégration de la reconnaissance vocale (Whisper)
- [ ] Intégration d'un LLM local (Ollama)
- [ ] Module de vision basique (détection de visage)

### Phase 3 — Expérience
- [ ] Affichage émotionnel (OLED / NeoPixel)
- [ ] Navigation autonome avec évitement d'obstacles
- [ ] Interface de contrôle web

### Phase 4 — Finitions
- [ ] Documentation complète
- [ ] Packaging et instructions d'assemblage
- [ ] Optimisation des performances embarquées

---

## 📦 Liste des Composants (BOM)

> La liste complète des composants matériels est disponible dans [`hardware/BOM.md`](hardware/BOM.md).

Composants principaux envisagés :
- Raspberry Pi 4 (4 Go RAM minimum)
- Arduino Nano / ESP32
- Moteurs DC avec encodeurs + driver L298N
- Caméra Raspberry Pi (module v2 ou v3)
- Microphone USB ou ReSpeaker
- Haut-parleur mini + amplificateur PAM8403
- Écran OLED 128x64 (SSD1306)
- Batterie LiPo + module de charge

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour proposer une modification :

1. Forkez le dépôt
2. Créez une branche (`git checkout -b feature/ma-fonctionnalite`)
3. Commitez vos changements (`git commit -m 'feat: ajout de X'`)
4. Poussez la branche (`git push origin feature/ma-fonctionnalite`)
5. Ouvrez une Pull Request

---

## 📄 Licence

Ce projet est sous licence **MIT** — voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👤 Auteur

Développé par **[@hmzoo](https://github.com/hmzoo)** — ingénieur logiciel passionné de robotique et d'IA.

---

> *"AVO, ton compagnon du quotidien."* 🤖💚
