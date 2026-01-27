"""
Agent Visuel Avo - Backend Flask
Interface web avec historique de conversation et génération vidéo
"""
# Patch TTS pour PyTorch 2.6+ avant tout import de TTS
import tts_patch

from flask import Flask, render_template, request, jsonify, send_file
from flask_socketio import SocketIO, emit
import os
import json
from datetime import datetime
from pathlib import Path
import subprocess
from threading import Thread
import torch
from TTS.api import TTS

app = Flask(__name__)
app.config['SECRET_KEY'] = 'avo-secret-key'
socketio = SocketIO(app, cors_allowed_origins="*")

# Chemins
BASE_DIR = Path(__file__).parent
MEDIA_DIR = BASE_DIR / "medias"
RESULTS_DIR = BASE_DIR / "results"
HISTORY_FILE = BASE_DIR / "conversation_history.json"
AUDIO_DIR = BASE_DIR / "audio"

# Créer les dossiers nécessaires
RESULTS_DIR.mkdir(exist_ok=True)
AUDIO_DIR.mkdir(exist_ok=True)

class AvoAgent:
    def __init__(self):
        self.face_image = str(MEDIA_DIR / "face.png")
        self.tts = None
        self.history = self.load_history()
        
    def initialize_tts(self):
        """Initialise le modèle TTS (peut prendre du temps)"""
        if self.tts is None:
            print("🔄 Chargement du modèle TTS...")
            self.tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2")
            print("✅ Modèle TTS chargé")
    
    def load_history(self):
        """Charge l'historique depuis le fichier JSON"""
        if HISTORY_FILE.exists():
            with open(HISTORY_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        return []
    
    def save_history(self):
        """Sauvegarde l'historique"""
        with open(HISTORY_FILE, 'w', encoding='utf-8') as f:
            json.dump(self.history, f, ensure_ascii=False, indent=2)
    
    def add_to_history(self, user_input, agent_response):
        """Ajoute une entrée à l'historique"""
        entry = {
            "timestamp": datetime.now().isoformat(),
            "user": user_input,
            "agent": agent_response,
            "video_path": None
        }
        self.history.append(entry)
        self.save_history()
        return len(self.history) - 1
    
    def generate_speech(self, text, output_filename="output.wav"):
        """Génère l'audio depuis le texte"""
        self.initialize_tts()
        audio_path = AUDIO_DIR / output_filename
        
        print(f"🎤 Génération audio : {text}")
        
        # XTTS v2 est multi-locuteur, utiliser un speaker par défaut
        # Liste des speakers disponibles : https://huggingface.co/coqui/XTTS-v2
        self.tts.tts_to_file(
            text=text,
            file_path=str(audio_path),
            language="fr",
            speaker="Claribel Dervla"  # Speaker féminin anglais par défaut
        )
        print(f"✅ Audio généré : {audio_path}")
        return str(audio_path)
    
    def animate_face(self, audio_path, output_name="animated"):
        """Anime le visage avec SadTalker via API Gradio"""
        print(f"🎬 Animation du visage via API Gradio...")
        
        # Vérifier si l'API Gradio est disponible
        try:
            import requests
            response = requests.get("http://localhost:7860", timeout=2)
            if response.status_code != 200:
                print("⚠️  API SadTalker non disponible sur http://localhost:7860")
                print("   Lancez-la avec: ./start_sadtalker_api.sh")
                return None
        except requests.exceptions.RequestException:
            print("⚠️  API SadTalker non accessible")
            print("   Lancez-la avec: ./start_sadtalker_api.sh")
            return None
        
        try:
            import requests
            from gradio_client import Client
            
            print("📡 Connexion à l'API Gradio...")
            client = Client("http://localhost:7860")
            
            # Appeler l'API Gradio de SadTalker
            print("🎨 Génération de l'animation...")
            result = client.predict(
                {"path": self.face_image},  # source_image (dict with path)
                audio_path,                 # driven_audio (filepath)
                "full",                     # preprocess
                True,                       # still_mode
                True,                       # enhancer
                api_name="/predict"
            )
            
            # result contient le chemin de la vidéo générée
            if result and os.path.exists(result):
                print(f"✅ Animation terminée: {result}")
                # Copier dans notre dossier results
                import shutil
                output_path = RESULTS_DIR / f"{output_name}_{os.path.basename(result)}"
                shutil.copy(result, output_path)
                return str(output_path)
            else:
                print("❌ Aucune vidéo générée")
                
        except ImportError:
            print("⚠️  Module gradio_client manquant")
            print("   Installez-le avec: pip install gradio_client")
        except Exception as e:
            print(f"❌ Erreur animation: {e}")
        
        return None
    
    def process_interaction(self, user_input):
        """Traite une interaction complète"""
        # Simple réponse (à remplacer par un LLM)
        agent_response = self.generate_response(user_input)
        
        # Ajouter à l'historique
        history_id = self.add_to_history(user_input, agent_response)
        
        # Générer audio
        audio_filename = f"audio_{history_id}.wav"
        audio_path = self.generate_speech(agent_response, audio_filename)
        
        # Animer (en arrière-plan pour ne pas bloquer)
        print(f"🎬 Début animation pour audio: {audio_path}")
        video_path = self.animate_face(audio_path, f"video_{history_id}")
        print(f"📹 Résultat animation: {video_path}")
        
        # Mettre à jour l'historique avec le chemin vidéo
        if video_path:
            self.history[history_id]["video_path"] = video_path
            self.save_history()
            print(f"✅ Vidéo sauvegardée: {video_path}")
        else:
            print(f"⚠️  Aucune vidéo générée")
        
        return {
            "response": agent_response,
            "audio_path": audio_path,
            "video_path": video_path,
            "history_id": history_id
        }
    
    def generate_response(self, user_input):
        """Génère une réponse (à améliorer avec un LLM)"""
        user_lower = user_input.lower()
        
        if "bonjour" in user_lower or "salut" in user_lower:
            return "Bonjour ! Je suis Avo, votre agent visuel. Comment puis-je vous aider ?"
        elif "comment" in user_lower and "vas" in user_lower:
            return "Je vais très bien, merci ! Prêt à discuter avec vous."
        elif "merci" in user_lower:
            return "De rien, c'est un plaisir de vous aider !"
        elif "aurevoir" in user_lower or "au revoir" in user_lower:
            return "Au revoir ! À bientôt !"
        else:
            return f"Vous avez dit : {user_input}. Je comprends et je suis là pour vous aider !"

# Instance globale
agent = AvoAgent()

@app.route('/')
def index():
    """Page principale"""
    return render_template('index.html')

@app.route('/api/history')
def get_history():
    """Récupère l'historique complet"""
    return jsonify(agent.history)

@app.route('/api/interact', methods=['POST'])
def interact():
    """Traite une interaction utilisateur"""
    data = request.json
    user_input = data.get('message', '')
    
    if not user_input:
        return jsonify({"error": "Message vide"}), 400
    
    # Notifier via WebSocket que le traitement commence
    socketio.emit('processing', {'message': 'Traitement en cours...'})
    
    # Traiter l'interaction
    result = agent.process_interaction(user_input)
    
    # Notifier la fin du traitement
    socketio.emit('response_ready', result)
    
    return jsonify(result)

@app.route('/api/audio/<path:filename>')
def serve_audio(filename):
    """Sert les fichiers audio"""
    return send_file(AUDIO_DIR / filename)

@app.route('/api/video/<path:filename>')
def serve_video(filename):
    """Sert les fichiers vidéo"""
    video_path = RESULTS_DIR / filename
    if video_path.exists():
        return send_file(video_path)
    return jsonify({"error": "Vidéo non trouvée"}), 404

@app.route('/medias/<path:filename>')
def serve_media(filename):
    """Sert les fichiers media (images, etc.)"""
    return send_file(MEDIA_DIR / filename)

@socketio.on('connect')
def handle_connect():
    print('Client connecté')
    emit('history', agent.history)

@socketio.on('send_message')
def handle_message(data):
    """Gestion des messages via WebSocket"""
    user_input = data.get('message', '')
    result = agent.process_interaction(user_input)
    emit('response', result, broadcast=True)

if __name__ == '__main__':
    print("🚀 Démarrage de l'agent Avo...")
    print(f"📁 Dossier medias: {MEDIA_DIR}")
    print(f"📁 Dossier results: {RESULTS_DIR}")
    print(f"🌐 Interface web: http://localhost:5000")
    
    socketio.run(app, host='0.0.0.0', port=5000, debug=False, allow_unsafe_werkzeug=True)
