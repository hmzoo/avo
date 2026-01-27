#!/bin/bash
# Lance la CLI avec l'environnement virtuel

# Vérifier si venv existe
if [ ! -d "venv" ]; then
    echo "❌ Environnement virtuel non trouvé"
    echo "   Lancez d'abord: ./setup.sh"
    exit 1
fi

# Activer l'environnement virtuel
source venv/bin/activate

# Lancer la CLI
echo "💬 CLI Avo - Mode interactif"
echo ""
python cli.py "$@"
