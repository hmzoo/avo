# 🥑 Avo - Agent Visuel Interactif

Agent visuel qui réagit et change d'expression en fonction des échanges, avec synthèse vocale et animation faciale.

> **🚀 [Guide de démarrage rapide](QUICKSTART.md)** - Lancez Avo en 2 minutes !

## 🌟 Fonctionnalités

- 💬 **Interface web** avec historique complet des conversations
- 🎤 **Synthèse vocale** (TTS) en français avec XTTS v2
- 🎬 **Animation faciale** synchronisée avec SadTalker
- 🖥️ **CLI** pour interactions en ligne de commande
- 💾 **Historique persistant** en JSON
- 🔄 **Mises à jour en temps réel** via WebSockets

## 📁 Structure du projet

```
avo/
├── venv/                      # Environnement virtuel (créé auto)
├── app.py                     # Backend Flask + API
├── cli.py                     # Interface ligne de commande
├── setup.sh                   # Script d'installation avec venv
├── start_web.sh              # Lance l'interface web
├── start_cli.sh              # Lance la CLI
├── templates/
│   └── index.html            # Interface web
├── medias/
│   └── face.png              # Image de base de l'agent
├── audio/                    # Fichiers audio générés (créé auto)
├── results/                  # Vidéos animées (créé auto)
├── conversation_history.json # Historique (créé auto)
├── requirements.txt          # Dépendances Python
└── install_sadtalker.sh     # Script d'installation SadTalker
```

## 🚀 Installation

### Prérequis

- **Python 3.9, 3.10 ou 3.11** (TTS ne supporte pas encore Python 3.12+)
- Git (pour SadTalker optionnel)

> **⚠️ Important**: Si vous avez Python 3.12 ou supérieur, installez Python 3.11 :
> ```bash
> sudo apt install python3.11 python3.11-venv  # Ubuntu/Debian
> # ou utilisez pyenv pour gérer plusieurs versions
> ```

### Installation rapide (avec environnement virtuel)

```bash
# 1. Cloner ou se placer dans le dossier
cd /home/mrpink/perso/avo

# 2. Lancer l'installation automatique
chmod +x setup.sh
./setup.sh
```

Le script `setup.sh` va :
- Créer un environnement virtuel Python (`venv/`)
- Installer toutes les dépendances
- Configurer le projet

### Installation manuelle

Si vous préférez installer manuellement :

```bash
# Créer l'environnement virtuel
python3 -m venv venv

# Activer l'environnement virtuel
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt
```

### (Optionnel) Installer SadTalker pour l'animation

```bash
./install_sadtalker.sh
```

> **Note**: SadTalker est optionnel. Sans lui, l'agent générera uniquement l'audio.

## 🏗️ Architecture

Le projet utilise une architecture à deux services:

### Service 1: API SadTalker (Gradio)
- Port: 7860
- Rôle: Génération des animations faciales
- Interface: API Gradio
- Isolation: Dépendances séparées pour éviter les conflits

### Service 2: Application Avo (Flask)
- Port: 5000
- Rôle: Interface utilisateur, TTS, orchestration
- Composants:
  - **app.py**: Application Flask principale avec:
    - Classe `AvoAgent` pour gérer TTS et animation
    - Routes API pour l'interface web
    - WebSocket pour communication temps réel
    - Client Gradio pour appeler SadTalker
  
  - **cli.py**: Interface en ligne de commande
    - Mode interactif
    - Envoi de messages directs
    - Consultation de l'historique

  - **templates/index.html**: Interface web
    - Chat en temps réel
    - Lecture audio/vidéo
    - Historique des échanges

### Dépendances principales
- Coqui TTS pour la synthèse vocale
- SadTalker (API Gradio) pour l'animation faciale
- Flask + SocketIO pour le backend
- PyTorch pour le deep learning
- gradio-client pour communiquer avec SadTalker

## 📖 Utilisation

> **Note**: Assurez-vous d'avoir activé l'environnement virtuel avant de lancer l'application :
> ```bash
> source venv/bin/activate
> ```
> Ou utilisez les scripts de lancement fournis.

### Option 1: Tout lancer ensemble (recommandé)

```bash
./start_all.sh
```

Cette commande lance:
- L'API SadTalker sur http://localhost:7860
- L'application Avo sur http://localhost:5000

Les services tournent dans une session tmux. Commandes utiles:
- `tmux attach -t avo` - Voir les logs
- `Ctrl+B puis 0 ou 1` - Changer de fenêtre
- `Ctrl+B puis D` - Détacher sans arrêter
- `tmux kill-session -t avo` - Arrêter tout

### Option 2: Lancement manuel

**Terminal 1: API SadTalker**
```bash
./start_sadtalker_api.sh
```

**Terminal 2: Application Avo**
```bash
./start_web.sh
```

Ouvrez votre navigateur sur http://localhost:5000

### Interface Web (recommandé)

**Méthode 1 - Script de lancement:**
```bash
./start_web.sh
```

**Méthode 2 - Manuel:**
```bash
source venv/bin/activate
python app.py
```

Puis ouvrez dans votre navigateur:
**Méthode manuelle:**

```bash
source venv/bin/activate

# Mode interactif
python cli.py -i

# Envoyer un message simple
python cli.py -m "Bonjour Avo, comment vas-tu ?"

# Afficher l'historique
python cli.py -H

# Aide_cli.sh -i

# Message simple
./start_cli.sh -m "Bonjour Avo !"

# Afficher l'historique
./start_cli.sh -H
```

**Méthode manuelle:**

#### Mode interactif
```bash
python cli.py -i
```

#### Envoyer un message simple
```bash
python cli.py -m "Bonjour Avo, comment vas-tu ?"
```

#### Afficher l'historique
```bash
python cli.py -H
```

#### Aide
```bash
python cli.py --help
```

## 🎯 Exemples d'utilisation

### Via CLI
```bash
# Mode interactif
$ python cli.py -i
👤 Vous: Bonjour !
🤖 Avo: Bonjour ! Je suis Avo, votre agent visuel. Comment puis-je vous aider ?

# Message direct
$ python cli.py -m "Raconte-moi une histoire"
🤖 Avo: Vous avez dit : Raconte-moi une histoire. Je comprends et je suis là pour vous aider !
🎵 Audio généré: audio/audio_1.wav
🎬 Vidéo générée: results/video_1.mp4
```

### Via Interface Web
1. Ouvrez http://localhost:5000
2. Tapez votre message dans la zone de texte
3. L'agent répond avec:
   - Texte affiché dans l'historique
   - Audio jouée automatiquement
   - Vidéo animée (si SadTalker installé)

## 🔧 Configuration

### Personnaliser l'image de l'agent
Remplacez `medias/face.png` par votre propre image (format PNG recommandé).

### Ajouter un LLM pour des réponses intelligentes
Dans [app.py](app.py), modifiez la méthode `generate_response()` pour intégrer OpenAI, Claude, etc:

```python
def generate_response(self, user_input):
    # Exemple avec OpenAI
    import openai
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "user", "content": user_input}]
    )
    return response.choices[0].message.content
```

### Clonage de voix
Pour utiliser une voix de référence avec TTS:

```python
tts.tts_to_file(
    text=text,
    file_path=str(audio_path),
    speaker_wav="medias/reference_voice.wav",  # Ajoutez votre voix
    language="fr"
)
```

## 📊 API Endpoints

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/` | GET | Interface web principale |
| `/api/history` | GET | Récupère l'historique complet |
| `/api/interact` | POST | Envoie un message à l'agent |
| `/api/audio/<filename>` | GET | Sert les fichiers audio |
| `/api/video/<filename>` | GET | Sert les fichiers vidéo |

## 🐛 Dépannage

### API SadTalker non accessible
Vérifiez que l'API tourne:
```bash
curl http://localhost:7860
```

Si l'API n'est pas lancée:
```bash
./start_sadtalker_api.sh
```

### Erreur "TTS not initialized"
L'initialisation est automatique au premier usage. Si elle échoue:
```bash
source venv/bin/activate
python -c "from TTS.api import TTS; tts = TTS('tts_models/multilingual/multi-dataset/xtts_v2')"
```

### Erreur lors de l'animation
Vérifiez les logs de SadTalker:
```bash
tmux attach -t avo
# Puis Ctrl+B puis 0 pour voir la fenêtre SadTalker
```

### Port déjà utilisé
Changez le port dans [app.py](app.py):
```python
socketio.run(app, debug=True, port=5001)  # Au lieu de 5000
```

Ou pour SadTalker, modifiez [start_sadtalker_api.sh](start_sadtalker_api.sh):
```bash
python app_sadtalker.py --server_port 7861
```

### tmux non installé
```bash
sudo apt install tmux
```

### Le serveur ne démarre pas
```bash
# Vérifier que le port 5000 est libre
lsof -i :5000
# Si occupé, modifier le port dans app.py
```

### SadTalker ne fonctionne pas
- Vérifiez que vous avez une carte graphique compatible
- Assurez-vous d'avoir téléchargé les modèles
- Le système fonctionne sans SadTalker (audio uniquement)

### Erreur TTS
```bash
# Réinstaller TTS
pip uninstall TTS
pip install TTS --no-cache-dir
```

## 🎨 Personnalisation

### Ajouter des émotions
Modifiez `generate_response()` pour détecter les émotions:

```python
def detect_emotion(self, text):
    if any(word in text.lower() for word in ['triste', 'malheureux']):
        return 'sad'
    elif any(word in text.lower() for word in ['content', 'heureux', 'super']):
        return 'happy'
    return 'neutral'
```

### Modifier l'interface
Éditez [templates/index.html](templates/index.html) pour personnaliser les couleurs, la mise en page, etc.

## 📝 Technologies utilisées

- **Backend**: Flask + Flask-SocketIO
- **TTS**: Coqui TTS (XTTS v2)
- **Animation**: SadTalker
- **Frontend**: HTML/CSS/JavaScript + Socket.IO
- **Deep Learning**: PyTorch

## 🤝 Contribution

Pour améliorer le projet:
1. Ajoutez un LLM pour des réponses intelligentes
2. Implémentez la détection d'émotions
3. Créez plus d'expressions faciales
4. Ajoutez la reconnaissance vocale (STT)

## 📄 Licence

MIT

## 🆘 Support

Pour toute question ou problème, consultez la documentation ou créez une issue.