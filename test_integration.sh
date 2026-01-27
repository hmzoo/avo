#!/bin/bash
# Test de l'intégration complète Avo

echo "🧪 Test de l'intégration Avo + SadTalker"
echo ""

# Vérifier que les deux services tournent
echo "1️⃣ Vérification des services..."

if curl -s http://localhost:7860 -o /dev/null; then
    echo "   ✅ API SadTalker (port 7860)"
else
    echo "   ❌ API SadTalker non accessible"
    echo "      Lancez: ./start_sadtalker_api.sh"
    exit 1
fi

if curl -s http://localhost:5000 -o /dev/null; then
    echo "   ✅ Application Avo (port 5000)"
else
    echo "   ❌ Application Avo non accessible"
    echo "      Lancez: ./start_web.sh"
    exit 1
fi

echo ""
echo "2️⃣ Test d'interaction..."

# Envoyer un message de test
RESPONSE=$(curl -s -X POST http://localhost:5000/api/interact \
    -H "Content-Type: application/json" \
    -d '{"message": "Bonjour, je teste l'\''intégration!"}')

echo "   Réponse reçue"

# Vérifier si un fichier audio a été généré
if ls audio/audio_*.wav 1> /dev/null 2>&1; then
    LATEST_AUDIO=$(ls -t audio/audio_*.wav | head -1)
    echo "   ✅ Audio généré: $LATEST_AUDIO"
    
    # Vérifier la taille du fichier
    SIZE=$(stat -f%z "$LATEST_AUDIO" 2>/dev/null || stat -c%s "$LATEST_AUDIO" 2>/dev/null)
    echo "   📊 Taille: $SIZE bytes"
else
    echo "   ⚠️  Aucun audio généré"
fi

# Vérifier si une vidéo a été générée
echo ""
echo "3️⃣ Vérification de l'animation..."
if ls results/*.mp4 1> /dev/null 2>&1; then
    LATEST_VIDEO=$(ls -t results/*.mp4 | head -1)
    echo "   ✅ Vidéo générée: $LATEST_VIDEO"
    SIZE=$(stat -f%z "$LATEST_VIDEO" 2>/dev/null || stat -c%s "$LATEST_VIDEO" 2>/dev/null)
    echo "   📊 Taille: $SIZE bytes"
else
    echo "   ⚠️  Aucune vidéo générée (vérifiez les logs)"
fi

echo ""
echo "✅ Test terminé"
echo ""
echo "Pour voir l'interface web: http://localhost:5000"
echo "Pour voir l'API SadTalker: http://localhost:7860"
