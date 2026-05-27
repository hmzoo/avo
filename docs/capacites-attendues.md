# Capacités attendues du robot AVO

## Contexte

AVO est un compagnon robotique basé sur une carte ESP32 T-Camera avec caméra OV2640, écran OLED et un cerveau IA hébergé sur une VM accessible via des API sécurisées.

L'objectif du robot est d'interagir naturellement avec son environnement et avec l'utilisateur, tout en gardant une architecture embarquée simple côté robot et des fonctions cognitives plus avancées côté serveur.

## Principes de conception

Les capacités d'AVO doivent être organisées autour de quatre piliers : percevoir, entendre, parler et agir.

Dans cette première version, le robot doit rester autonome pour les fonctions critiques locales, tout en s'appuyant sur la VM pour l'intelligence conversationnelle, l'interprétation avancée et la personnalisation.

## Capacités attendues

### 1. Voir et percevoir l'environnement

AVO doit être capable d'observer son environnement immédiat grâce à sa caméra embarquée et d'extraire des informations simples utiles au comportement du robot.

Capacités attendues :
- Capturer des images à la demande ou sur événement.
- Détecter un mouvement ou une présence probable dans le champ de vision.
- Identifier des situations simples, par exemple une pièce vide, une arrivée dans le champ ou un changement visuel important.
- Envoyer une image ou un résumé d'observation à la VM pour analyse plus avancée.

### 2. Entendre l'utilisateur

La capacité d'entendre est une fonction centrale d'AVO, car un robot compagnon doit pouvoir repérer qu'on s'adresse à lui et transmettre une entrée audio exploitable au système d'IA.

Capacités attendues :
- Détecter qu'une personne parle à proximité ou qu'un son pertinent est présent.
- Déclencher une écoute sur mot-clé, bouton, événement ou mode d'interaction défini.
- Capturer une commande vocale courte et l'envoyer à la VM pour transcription et compréhension.
- Signaler visuellement qu'AVO est en train d'écouter, afin de rendre l'interaction claire pour l'utilisateur.

### 3. Parler et répondre vocalement

La capacité de parler doit être considérée comme aussi importante que la capacité d'entendre, car elle constitue la forme de retour la plus naturelle pour un compagnon robotique conversationnel.

Comme l'ESP32 ne dispose pas des ressources nécessaires pour une synthèse vocale avancée locale, l'architecture avec génération distante de la voix puis lecture audio côté ESP32 est adaptée à ce projet.

Capacités attendues :
- Recevoir depuis la VM une réponse textuelle ou un flux audio prêt à être joué.
- Restituer une réponse orale claire via un haut-parleur et un étage audio adaptés (I2S, etc.).
- Utiliser la voix pour confirmer une action, saluer, prévenir, rassurer ou dialoguer simplement avec l'utilisateur.
- Synchroniser la parole avec un état visuel sur l'écran OLED, par exemple yeux animés ou icône d'écoute/parole.

### 4. Dialoguer de manière simple et naturelle

AVO doit pouvoir soutenir des interactions courtes, compréhensibles et utiles, plutôt que chercher immédiatement à devenir un assistant conversationnel complet.

Capacités attendues :
- Répondre à des salutations, questions courtes ou ordres simples.
- Maintenir un échange bref autour d'un contexte immédiat, par exemple « je t'écoute », « j'ai détecté un mouvement » ou « je n'ai pas compris ».
- Adapter la réponse en fonction du contexte remonté par les capteurs ou de l'état interne du robot.
- Offrir un comportement conversationnel robuste, contrôlable et prévisible.

### 5. S'exprimer visuellement

AVO doit pouvoir exprimer son état et une partie de son intention à travers l'écran OLED, afin que l'utilisateur comprenne rapidement ce qu'il fait.

Capacités attendues :
- Afficher des yeux, émotions simples ou états symboliques.
- Montrer les états d'écoute, de réflexion, de parole, d'attente ou d'erreur.
- Renforcer la lisibilité de l'interaction lorsque l'audio n'est pas disponible ou pas suffisant.

### 6. Agir localement

Le robot doit pouvoir exécuter localement les actions utiles et critiques sans dépendre en permanence du serveur distant.

Capacités attendues :
- Exécuter des actions courtes et déterministes, par exemple s'arrêter, démarrer, changer d'expression ou orienter un comportement moteur.
- Appliquer localement les règles de sûreté et les limites de mouvement.
- Continuer à fonctionner dans un mode dégradé si la VM est indisponible.

### 7. Communiquer avec le cerveau IA distant

Le lien entre AVO et la VM doit permettre d'envoyer des observations et de recevoir des intentions de haut niveau de manière fiable et sécurisée.

Capacités attendues :
- Envoyer des événements structurés, des états internes et des captures vers l'API distante.
- Recevoir des intentions telles que parler, afficher, surveiller, attendre ou déclencher une routine.
- Sécuriser les échanges par HTTPS, authentification forte et contrôle des requêtes.

### 8. Rester sûr, fiable et compréhensible

Un robot compagnon doit être prévisible dans son comportement, surtout lorsqu'il se déplace ou lorsqu'il collecte des données audio et visuelles.

Capacités attendues :
- Indiquer clairement quand il écoute, enregistre, transmet ou parle.
- Respecter des règles de sécurité locale en cas de panne réseau ou de commande invalide.
- Donner à l'utilisateur un comportement simple à comprendre, avec des états explicites et peu ambigus.

## Priorités pour la v1

### Priorité haute
- Entendre une commande courte.
- Envoyer l'audio ou sa transcription à la VM.
- Recevoir une réponse du backend IA.
- Parler à l'utilisateur avec une restitution vocale simple.
- Afficher clairement les états écouter, réfléchir, parler et erreur.

### Priorité moyenne
- Détecter une présence ou un mouvement.
- Joindre une image ou un contexte visuel à une demande IA.
- Personnaliser certaines réponses ou routines selon l'usage.

### Priorité ultérieure
- Conversation plus riche et mémoire relationnelle avancée.
- Navigation plus autonome.
- Comportements expressifs plus complexes, synchronisés avec la voix.

## Formulation synthétique du besoin

AVO doit être capable de voir ce qui se passe autour de lui, d'entendre qu'on lui parle, de transmettre cette demande à un cerveau IA distant, puis de répondre avec une voix et une expression compréhensibles, tout en gardant un comportement local sûr et fiable.
