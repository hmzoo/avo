#!/bin/bash
# Lance l'API SadTalker et l'application Avo ensemble

echo "🚀 Démarrage d'Avo avec animation faciale"
echo ""

# Vérifier si tmux est installé
if ! command -v tmux &> /dev/null; then
    echo "❌ tmux n'est pas installé"
    echo "   Installation: sudo apt install tmux"
    exit 1
fi

# Créer une session tmux
SESSION="avo"

# Tuer la session si elle existe déjà
tmux kill-session -t $SESSION 2>/dev/null

# Créer une nouvelle session
tmux new-session -d -s $SESSION

# Fenêtre 0: API SadTalker
tmux rename-window -t $SESSION:0 'SadTalker-API'
tmux send-keys -t $SESSION:0 "cd $(dirname "$0") && ./start_sadtalker_api.sh" C-m

# Attendre que l'API démarre
echo "⏳ Démarrage de l'API SadTalker (30s)..."
sleep 30

# Fenêtre 1: Application Flask
tmux new-window -t $SESSION:1 -n 'Flask-App'
tmux send-keys -t $SESSION:1 "cd $(dirname "$0") && ./start_web.sh" C-m

echo ""
echo "✅ Services lancés dans la session tmux '$SESSION'"
echo ""
echo "📋 Commandes utiles:"
echo "   - Voir les logs:    tmux attach -t $SESSION"
echo "   - Changer fenêtre:  Ctrl+B puis 0 ou 1"
echo "   - Détacher:         Ctrl+B puis D"
echo "   - Arrêter tout:     tmux kill-session -t $SESSION"
echo ""
echo "🌐 Interfaces:"
echo "   - API SadTalker:    http://localhost:7860"
echo "   - Application Avo:  http://localhost:5000"
echo ""
