# Architecture du projet AVO

## Vue d'ensemble

AVO repose sur un robot embarqué autour d'un ESP32 T-Camera et sur un cerveau IA distant hébergé sur une VM accessible via API sécurisée.

## Blocs principaux

- `firmware/esp32/` : code embarqué du robot, gestion caméra, OLED, audio, moteurs et communication réseau.
- `firmware/config/` : configuration matérielle, constantes, secrets non versionnés, profils d'environnement.
- `ai/api/` : spécification et implémentation du backend distant, endpoints, authentification et orchestration IA.
- `ai/schemas/` : formats JSON échangés entre le robot et la VM (événements, commandes, réponses).
- `hardware/bom/` : nomenclature matérielle et références composants.
- `hardware/schematics/` : schémas électroniques et interconnexions.
- `hardware/mechanics/` : châssis, pièces, assemblage mécanique.
- `docs/` : documentation produit, architecture et décisions.
- `tests/` : plans et scripts de validation.
- `tools/` : scripts utilitaires de développement.

## Principes

- Garder les fonctions critiques en local sur l'ESP32, notamment la sûreté et les réactions de base.
- Déporter l'intelligence conversationnelle et l'analyse avancée sur la VM.
- Documenter séparément les volets produit, matériel, logiciel et protocoles pour faciliter l'évolution du projet.
