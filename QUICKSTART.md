# 🚀 Guide de démarrage - Avo avec animation faciale

## État actuel ✅

- ✅ API SadTalker fonctionnelle sur http://localhost:7860
- ✅ Application Flask sur http://localhost:5000
- ✅ TTS (Coqui XTTS v2) opérationnel
- ✅ Intégration Gradio API configurée

## Démarrage rapide

### Option 1: Tout lancer (recommandé)

```bash
# Dans deux terminaux différents:

# Terminal 1 - API SadTalker
./start_sadtalker_api.sh

# Terminal 2 - Application Avo
./start_web.sh
```

### Option 2: En arrière-plan

```bash
# Lancer l'API SadTalker en arrière-plan
./start_sadtalker_api.sh > /tmp/sadtalker.log 2>&1 &

# Attendre 10 secondes
sleep 10

# Lancer Avo
./start_web.sh
```

### Option 3: Avec tmux (à venir)

```bash
./start_all.sh
```

## Vérification

### 1. Vérifier que les services tournent

```bash
# API SadTalker
curl http://localhost:7860

# Application Avo
curl http://localhost:5000
```

### 2. Voir les processus

```bash
ps aux | grep -E "app_simple|app.py" | grep -v grep
```

### 3. Tester l'intégration

```bash
./test_integration.sh
```

## Utilisation

### Interface Web

1. Ouvrir http://localhost:5000
2. Taper un message dans le champ de texte
3. Envoyer
4. L'agent va :
   - Générer une réponse
   - Créer l'audio (TTS)
   - Animer le visage (SadTalker)
   - Afficher la vidéo

### CLI

```bash
# Mode interactif
./start_cli.sh -i

# Message direct
./start_cli.sh -m "Bonjour Avo!"

# Voir l'historique
./start_cli.sh -H
```

## Arrêter les services

```bash
# Arrêter l'API SadTalker
pkill -f app_simple.py

# Arrêter l'application Flask
pkill -f "python.*app.py"

# Tout arrêter
pkill -f "app_simple.py\|python.*app.py"
```

## Logs et debug

### Voir les logs de l'API SadTalker

```bash
tail -f /tmp/sadtalker_api.log
```

### Voir les logs Flask

Les logs s'affichent directement dans le terminal où vous avez lancé `./start_web.sh`

### Tester l'API manuellement

```bash
source venv/bin/activate
python -c "
from gradio_client import Client
client = Client('http://localhost:7860')
print(client.view_api())
"
```

## Dépannage

### "API SadTalker non accessible"

```bash
# Vérifier que l'API tourne
ps aux | grep app_simple

# Si elle ne tourne pas, lancer:
./start_sadtalker_api.sh
```

### "Cannot find a function with api_name"

L'API a été corrigée pour exposer `/predict`. Redémarrez:

```bash
pkill -f app_simple.py
./start_sadtalker_api.sh
```

### Erreurs de dépendances

Les deux services ont des environnements séparés:
- **Avo**: `venv/` (Python 3.11)
- **SadTalker**: `SadTalker/venv_sadtalker/` (Python 3.11)

Cela évite les conflits de versions (torch, numpy, etc.)

### Port déjà utilisé

```bash
# Changer le port de SadTalker
# Éditer start_sadtalker_api.sh et changer --server_port

# Changer le port d'Avo
# Éditer app.py, ligne finale
```

## Architecture

```
┌─────────────┐
│  Navigateur │
│   :5000     │
└──────┬──────┘
       │ HTTP/WebSocket
       │
┌──────▼──────┐      gradio_client     ┌──────────────┐
│  Flask App  │ ────────────────────────▶│  SadTalker   │
│  (venv/)    │                          │  API :7860   │
│             │                          │ (venv_sadtalker/)│
│  - TTS      │                          │              │
│  - Routes   │◀─────────────────────────│  - Animation │
│  - WebSocket│      Vidéo générée       │  - Gradio    │
└─────────────┘                          └──────────────┘
```

## Fichiers importants

- `app.py` - Application Flask principale
- `start_web.sh` - Lance Flask
- `start_sadtalker_api.sh` - Lance l'API SadTalker
- `SadTalker/app_simple.py` - Interface Gradio moderne
- `test_integration.sh` - Test automatique
- `SADTALKER_STATUS.md` - État de la configuration SadTalker

## Prochaines étapes

- [ ] Tester génération vidéo complète
- [ ] Optimiser les performances
- [ ] Ajouter un LLM pour les réponses intelligentes
- [ ] Créer le script `start_all.sh` avec tmux
