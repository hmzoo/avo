#!/bin/bash
# Configure l'environnement virtuel séparé pour SadTalker

set -e

SADTALKER_DIR="$(dirname "$0")/SadTalker"

if [ ! -d "$SADTALKER_DIR" ]; then
    echo "❌ SadTalker non trouvé dans: $SADTALKER_DIR"
    echo "   Lancez d'abord: ./install_sadtalker.sh"
    exit 1
fi

cd "$SADTALKER_DIR"

echo "🔧 Configuration de l'environnement SadTalker..."
echo ""

# Supprimer l'ancien venv si demandé
if [ -d "venv_sadtalker" ]; then
    read -p "Un environnement existe déjà. Le recréer? (o/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[OoYy]$ ]]; then
        rm -rf venv_sadtalker
    else
        echo "✅ Conservation de l'environnement existant"
        exit 0
    fi
fi

# Créer le venv
echo "📦 Création du venv SadTalker..."
python3 -m venv venv_sadtalker

# Activer et installer
source venv_sadtalker/bin/activate

echo "⬆️  Mise à jour de pip..."
pip install --upgrade pip wheel setuptools

echo "📥 Installation des dépendances SadTalker..."
echo "   (Cela peut prendre 5-10 minutes)"
echo ""

pip install -r requirements_api.txt

echo ""
echo "✅ Environnement SadTalker configuré avec succès !"
echo ""
echo "Pour démarrer l'API:"
echo "  ./start_sadtalker_api.sh"
