#!/bin/bash
# Test de l'intégration SadTalker API

echo "🧪 Test de l'intégration SadTalker"
echo ""

cd "$(dirname "$0")"

# Activer l'environnement virtuel
source venv/bin/activate

# Tester la connexion à l'API
echo "1️⃣ Test de connexion à l'API SadTalker..."
if curl -s http://localhost:7860 > /dev/null 2>&1; then
    echo "✅ API SadTalker accessible sur http://localhost:7860"
else
    echo "❌ API SadTalker non accessible"
    echo "   Lancez-la avec: ./start_sadtalker_api.sh"
    exit 1
fi

# Tester l'import du client Gradio
echo ""
echo "2️⃣ Test du client Gradio..."
python -c "from gradio_client import Client; print('✅ gradio-client OK')" || {
    echo "❌ Erreur import gradio-client"
    exit 1
}

# Tester la création du client
echo ""
echo "3️⃣ Test de création du client..."
python -c "
from gradio_client import Client
try:
    client = Client('http://localhost:7860')
    print('✅ Client créé avec succès')
except Exception as e:
    print(f'❌ Erreur: {e}')
    exit(1)
" || exit 1

echo ""
echo "✅ Tous les tests passés !"
echo ""
echo "Vous pouvez maintenant lancer l'application avec:"
echo "  ./start_web.sh"
