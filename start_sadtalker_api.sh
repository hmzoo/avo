#!/bin/bash
# Lance l'API SadTalker avec Gradio

SADTALKER_DIR="$(dirname "$0")/SadTalker"
cd "$SADTALKER_DIR"

# Créer le venv séparé si nécessaire
if [ ! -d "venv_sadtalker" ]; then
    echo "📦 Création de l'environnement virtuel pour SadTalker..."
    python3 -m venv venv_sadtalker
    
    echo "📥 Installation des dépendances SadTalker..."
    source venv_sadtalker/bin/activate
    pip install --upgrade pip
    pip install -r requirements_api.txt
    
    echo "✅ Environnement SadTalker prêt"
    echo ""
fi

# Activer l'environnement virtuel SadTalker
source venv_sadtalker/bin/activate

echo "🚀 Démarrage de l'API SadTalker (Gradio)..."
echo "🌐 L'API sera disponible sur http://localhost:7860"
echo ""
echo "⚠️  Gardez ce terminal ouvert pendant l'utilisation d'Avo"
echo ""

# Lancer l'application Gradio (version simple compatible)
python app_simple.py --server_name 0.0.0.0 --server_port 7860
