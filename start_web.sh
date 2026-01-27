#!/bin/bash
# Lance l'interface web avec l'environnement virtuel

# Vérifier si venv existe
if [ ! -d "venv" ]; then
    echo "❌ Environnement virtuel non trouvé"
    echo "   Lancez d'abord: ./setup.sh"
    exit 1
fi

# Activer l'environnement virtuel
source venv/bin/activate

# Lancer l'application
echo "🚀 Démarrage de l'interface web Avo..."
echo "🌐 Ouvrez votre navigateur: http://localhost:5000"
echo ""
python app.py
