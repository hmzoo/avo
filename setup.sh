#!/bin/bash
# Script d'installation avec environnement virtuel Python

set -e  # Arrêter en cas d'erreur

echo "🚀 Installation de l'agent Avo avec environnement virtuel"
echo "========================================================="
echo ""

# Vérifier Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas installé"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

echo "✅ Python détecté: $PYTHON_VERSION"

# Vérifier la compatibilité avec TTS (Coqui TTS nécessite Python < 3.12)
if [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 12 ]; then
    echo ""
    echo "⚠️  ATTENTION: Python $PYTHON_VERSION est trop récent !"
    echo "   TTS (Coqui TTS) nécessite Python 3.9, 3.10 ou 3.11"
    echo ""
    echo "Solutions possibles:"
    echo "  1. Installer Python 3.11:"
    echo "     sudo apt install python3.11 python3.11-venv"
    echo "     puis relancer avec: python3.11 -m venv venv"
    echo ""
    echo "  2. Utiliser pyenv pour gérer plusieurs versions Python"
    echo ""
    
    # Chercher Python 3.11 ou 3.10
    for pyver in python3.11 python3.10 python3.9; do
        if command -v $pyver &> /dev/null; then
            echo "✅ $pyver trouvé sur le système !"
            read -p "   Voulez-vous utiliser $pyver ? (Y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                PYTHON_CMD=$pyver
                echo "📌 Utilisation de $pyver"
                break
            fi
        fi
    done
    
    if [ -z "$PYTHON_CMD" ]; then
        echo "❌ Aucune version Python compatible trouvée"
        echo "   Installation annulée"
        exit 1
    fi
else
    PYTHON_CMD=python3
fi

echo ""

# Créer l'environnement virtuel
if [ -d "venv" ]; then
    echo "📦 Environnement virtuel existant trouvé"
    read -p "   Voulez-vous le recréer ? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Suppression de l'ancien venv..."
        rm -rf venv
    fi
fi

if [ ! -d "venv" ]; then
    echo "📦 Création de l'environnement virtuel avec $PYTHON_CMD..."
    $PYTHON_CMD -m venv venv
    echo "✅ Environnement virtuel créé"
fi

# Activer l'environnement virtuel
echo ""
echo "🔄 Activation de l'environnement virtuel..."
source venv/bin/activate

# Mettre à jour pip
echo "📦 Mise à jour de pip..."
pip install --upgrade pip setuptools wheel

# Installer les dépendances
echo ""
echo "📦 Installation des dépendances..."
pip install -r requirements.txt

echo ""
echo "✅ Installation terminée !"
echo ""
echo "========================================================="
echo "Pour utiliser l'application :"
echo ""
echo "  1. Activer l'environnement virtuel :"
echo "     source venv/bin/activate"
echo ""
echo "  2. Lancer l'interface web :"
echo "     python app.py"
echo "     ou: ./start_web.sh"
echo ""
echo "  3. Utiliser la CLI :"
echo "     python cli.py -i"
echo "     ou: ./start_cli.sh"
echo ""
echo "  4. (Optionnel) Installer SadTalker :"
echo "     ./install_sadtalker.sh"
echo ""
echo "========================================================="
