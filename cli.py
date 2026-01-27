#!/usr/bin/env python3
"""
CLI pour interagir avec l'agent Avo
Permet d'envoyer des messages depuis la ligne de commande
"""
import argparse
import requests
import sys
from pathlib import Path

API_URL = "http://localhost:5000"

def send_message(message):
    """Envoie un message à l'agent"""
    try:
        response = requests.post(
            f"{API_URL}/api/interact",
            json={"message": message},
            timeout=120
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"\n🤖 Avo: {data['response']}\n")
            
            if data.get('audio_path'):
                print(f"🎵 Audio généré: {data['audio_path']}")
            
            if data.get('video_path'):
                print(f"🎬 Vidéo générée: {data['video_path']}")
                
            return True
        else:
            print(f"❌ Erreur: {response.status_code}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Erreur: Impossible de se connecter au serveur.")
        print("   Assurez-vous que le serveur est lancé avec: python app.py")
        return False
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False

def get_history():
    """Affiche l'historique des conversations"""
    try:
        response = requests.get(f"{API_URL}/api/history")
        
        if response.status_code == 200:
            history = response.json()
            
            if not history:
                print("📝 Aucune conversation dans l'historique")
                return
            
            print("\n" + "="*60)
            print("📚 HISTORIQUE DES CONVERSATIONS")
            print("="*60 + "\n")
            
            for i, entry in enumerate(history, 1):
                timestamp = entry.get('timestamp', 'N/A')
                print(f"[{i}] {timestamp}")
                print(f"👤 Vous: {entry['user']}")
                print(f"🤖 Avo: {entry['agent']}")
                if entry.get('video_path'):
                    print(f"   🎬 Vidéo: {entry['video_path']}")
                print()
            
            print("="*60 + "\n")
        else:
            print(f"❌ Erreur: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Erreur: {e}")

def interactive_mode():
    """Mode interactif pour discuter avec l'agent"""
    print("\n" + "="*60)
    print("💬 MODE INTERACTIF - Agent Avo")
    print("="*60)
    print("Tapez vos messages (ou 'quit' pour quitter)\n")
    
    while True:
        try:
            user_input = input("👤 Vous: ").strip()
            
            if not user_input:
                continue
                
            if user_input.lower() in ['quit', 'exit', 'q']:
                print("\n👋 Au revoir !")
                break
            
            send_message(user_input)
            
        except KeyboardInterrupt:
            print("\n\n👋 Au revoir !")
            break
        except EOFError:
            break

def main():
    parser = argparse.ArgumentParser(
        description="CLI pour interagir avec l'agent visuel Avo",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemples:
  %(prog)s -m "Bonjour, comment vas-tu ?"     # Envoie un message
  %(prog)s -i                                  # Mode interactif
  %(prog)s -H                                  # Affiche l'historique
        """
    )
    
    parser.add_argument(
        '-m', '--message',
        type=str,
        help='Message à envoyer à l\'agent'
    )
    
    parser.add_argument(
        '-i', '--interactive',
        action='store_true',
        help='Mode interactif'
    )
    
    parser.add_argument(
        '-H', '--history',
        action='store_true',
        help='Affiche l\'historique des conversations'
    )
    
    parser.add_argument(
        '--url',
        type=str,
        default=API_URL,
        help=f'URL de l\'API (défaut: {API_URL})'
    )
    
    args = parser.parse_args()
    
    # Mettre à jour l'URL si spécifiée
    global API_URL
    API_URL = args.url
    
    # Si aucun argument, mode interactif par défaut
    if not any([args.message, args.interactive, args.history]):
        interactive_mode()
        return
    
    # Afficher l'historique
    if args.history:
        get_history()
        return
    
    # Mode interactif
    if args.interactive:
        interactive_mode()
        return
    
    # Envoyer un message
    if args.message:
        send_message(args.message)
        return

if __name__ == '__main__':
    main()
