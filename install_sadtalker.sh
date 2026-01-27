#!/bin/bash
# Installation optionnelle de SadTalker
# Ce script aide à installer SadTalker pour l'animation faciale

set -e

echo "🔧 Installation de SadTalker..."

# Vérifier si venv existe et l'activer
if [ -d "venv" ]; then
    echo "🔄 Activation de l'environnement virtuel..."
    source venv/bin/activate
else
    echo "⚠️  Environnement virtuel non trouvé"
    echo "   Continuons sans venv (non recommandé)"
fi

# Cloner SadTalker
if [ ! -d "SadTalker" ]; then
    echo "📥 Clonage de SadTalker..."
    git clone https://github.com/OpenTalker/SadTalker.git
    cd SadTalker
    
    # Installer les dépendances SadTalker
    echo "📦 Installation des dépendances SadTalker..."
    pip install -r requirements.txt
    
    # Télécharger les modèles pré-entrainés
    echo "📥 Téléchargement des modèles (cela peut prendre du temps)..."
    bash scripts/download_models.sh
    
    cd ..
    echo "✅ SadTalker installé avec succès"
else
    echo "✅ SadTalker déjà installé"
fi

echo ""
echo "📦 Installation terminée !"
echo "Vous pouvez maintenant lancer l'application avec: ./start_web.sh"
