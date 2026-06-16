# Souvenir Puzzle — Product Requirements Document

Version : 0.1
Projet : Koyra Games
Produit : Souvenir Puzzle
Type : Jeu mobile photo-puzzle
Plateforme MVP : Android
Plateforme future : iOS
Technologie recommandée : Flutter / Dart
Stockage : Local-first

---

# 1. Résumé du produit

**Souvenir Puzzle** est un jeu mobile simple, familial et émotionnel qui permet à l’utilisateur de choisir une photo depuis son téléphone et de la transformer automatiquement en puzzle.

Le joueur peut ainsi jouer avec ses propres souvenirs : famille, enfants, mariage, voyage, village, amis, moments importants, événements personnels.

Le jeu doit être très simple, propre, calme et accessible à tout le monde.

---

# 2. Vision produit

Souvenir Puzzle ne doit pas être seulement un jeu de puzzle.

Il doit être une expérience émotionnelle où chaque photo devient un moment à reconstruire.

Le jeu transforme une image personnelle en activité calme, familiale et mémorable.

---

# 3. Objectif du MVP

L’objectif du MVP est de créer une première version simple, jouable et publiable.

Le MVP doit permettre à l’utilisateur de :

1. ouvrir l’application ;
2. choisir une photo ;
3. choisir une difficulté ;
4. jouer au puzzle ;
5. terminer le puzzle ;
6. voir un écran de victoire ;
7. rejouer ou créer un nouveau puzzle.

Le MVP doit rester simple.
Il ne doit pas inclure de fonctionnalités lourdes comme compte utilisateur, cloud, multijoueur ou boutique.

---

# 4. Public cible

## 4.1 Public principal

* Familles
* Parents
* Enfants
* Couples
* Diaspora
* Seniors
* Joueurs casual

## 4.2 Public secondaire

* Utilisateurs qui aiment les jeux calmes
* Personnes qui aiment les souvenirs photo
* Personnes âgées qui veulent une activité simple
* Parents qui veulent un jeu propre pour leurs enfants

---

# 5. Problème utilisateur

Beaucoup de personnes ont des milliers de photos dans leur téléphone, mais elles les regardent rarement.

Souvenir Puzzle donne une nouvelle vie à ces photos en les transformant en jeu.

Le problème résolu :

> “J’ai des photos importantes, mais je veux une manière plus amusante, calme et émotionnelle de les revivre.”

---

# 6. Proposition de valeur

Souvenir Puzzle permet de :

* transformer ses propres photos en puzzles ;
* revivre ses souvenirs de manière interactive ;
* jouer sans connexion internet ;
* garder ses photos privées ;
* proposer un jeu simple pour toute la famille.

---

# 7. Positionnement

Phrase courte :

> Transformez vos photos en puzzles et revivez vos souvenirs pièce par pièce.

Phrase longue :

> Souvenir Puzzle est un jeu mobile familial qui transforme vos photos personnelles en puzzles simples, calmes et émotionnels.

---

# 8. Périmètre du MVP

## 8.1 Inclus dans le MVP

Le MVP inclut :

* écran d’accueil ;
* sélection d’une photo depuis la galerie ;
* aperçu de la photo choisie ;
* choix de difficulté ;
* génération du puzzle ;
* gameplay drag-and-drop ;
* compteur de temps ;
* compteur de mouvements ;
* bouton pause ;
* bouton aperçu de l’image complète ;
* détection de victoire ;
* écran de victoire ;
* historique local simple ;
* paramètres simples ;
* confidentialité locale.

## 8.2 Non inclus dans le MVP

Le MVP n’inclut pas :

* compte utilisateur ;
* connexion obligatoire ;
* sauvegarde cloud ;
* partage social avancé ;
* mode multijoueur ;
* classement en ligne ;
* publicité ;
* boutique premium ;
* formes de puzzle complexes ;
* intelligence artificielle ;
* albums collaboratifs.

---

# 9. Fonctionnalités détaillées

---

## 9.1 Écran d’accueil

### Objectif

Permettre à l’utilisateur de commencer rapidement.

### Éléments

* Logo Souvenir Puzzle
* Slogan court
* Bouton principal : “Créer un puzzle”
* Bouton secondaire : “Mes souvenirs”
* Bouton paramètres

### User Story

En tant qu’utilisateur, je veux ouvrir l’application et comprendre immédiatement comment commencer un puzzle.

### Critères d’acceptation

* L’utilisateur voit clairement le bouton “Créer un puzzle”.
* L’utilisateur peut accéder à ses anciens puzzles.
* L’utilisateur peut ouvrir les paramètres.
* L’écran est simple et lisible.

### Priorité

Must-have.

---

## 9.2 Sélection de photo

### Objectif

Permettre à l’utilisateur de choisir une photo depuis son téléphone.

### Éléments

* Bouton “Choisir une photo”
* Accès galerie
* Aperçu de la photo
* Bouton “Continuer”
* Message de confidentialité

Message recommandé :

> Vos photos restent sur votre téléphone.

### User Story

En tant qu’utilisateur, je veux choisir une photo personnelle pour la transformer en puzzle.

### Critères d’acceptation

* L’utilisateur peut ouvrir la galerie.
* L’utilisateur peut sélectionner une photo.
* L’image sélectionnée s’affiche correctement.
* L’utilisateur peut changer de photo avant de continuer.
* L’application demande les permissions nécessaires proprement.

### Priorité

Must-have.

---

## 9.3 Choix de difficulté

### Objectif

Permettre à l’utilisateur de choisir le niveau du puzzle.

### Difficultés MVP

| Niveau    | Grille | Public                      |
| --------- | -----: | --------------------------- |
| Facile    |  3 x 3 | Enfants, seniors, débutants |
| Moyen     |  4 x 4 | Joueurs casual              |
| Difficile |  5 x 5 | Joueurs plus patients       |

### User Story

En tant qu’utilisateur, je veux choisir une difficulté adaptée à mon niveau.

### Critères d’acceptation

* L’utilisateur peut sélectionner Facile, Moyen ou Difficile.
* Chaque difficulté affiche clairement le nombre de pièces.
* Le bouton “Commencer” lance le puzzle.
* La difficulté choisie est utilisée pour générer la grille.

### Priorité

Must-have.

---

## 9.4 Génération du puzzle

### Objectif

Transformer automatiquement la photo en puzzle.

### Fonctionnement

L’application doit :

1. charger l’image ;
2. redimensionner l’image si nécessaire ;
3. découper l’image en grille ;
4. créer les pièces ;
5. mélanger les pièces ;
6. préparer la zone de jeu.

### User Story

En tant qu’utilisateur, je veux que ma photo soit automatiquement transformée en puzzle.

### Critères d’acceptation

* La photo est découpée selon la difficulté choisie.
* Les pièces sont mélangées.
* Le puzzle est jouable.
* L’image ne doit pas être déformée de manière excessive.
* Le chargement doit rester rapide.

### Priorité

Must-have.

---

## 9.5 Écran de jeu

### Objectif

Permettre au joueur de résoudre le puzzle.

### Éléments

* Zone de puzzle
* Pièces mélangées
* Compteur de temps
* Compteur de mouvements
* Bouton pause
* Bouton aperçu
* Bouton recommencer

### User Story

En tant que joueur, je veux déplacer les pièces pour reconstruire ma photo.

### Critères d’acceptation

* Le joueur peut déplacer une pièce avec le doigt.
* Une pièce peut être échangée avec une autre.
* Le nombre de mouvements augmente après chaque déplacement valide.
* Le temps commence quand le puzzle démarre.
* Le jeu détecte quand toutes les pièces sont bien placées.
* L’écran reste fluide.

### Priorité

Must-have.

---

## 9.6 Système de déplacement

### Objectif

Créer une mécanique simple et intuitive.

### Mécanique MVP recommandée

Le joueur glisse une pièce vers une autre position.
Si la position contient déjà une pièce, les deux pièces échangent leur place.

### User Story

En tant que joueur, je veux déplacer les pièces facilement sans comprendre des règles compliquées.

### Critères d’acceptation

* Le drag-and-drop fonctionne correctement.
* Les pièces restent dans la zone de puzzle.
* Les échanges de positions sont clairs.
* Une animation légère accompagne le déplacement.
* Le joueur ne perd pas sa progression pendant le jeu.

### Priorité

Must-have.

---

## 9.7 Bouton aperçu

### Objectif

Aider le joueur à voir l’image originale.

### Fonctionnement

Le joueur peut appuyer sur un bouton pour voir l’image complète pendant quelques secondes ou jusqu’à fermeture manuelle.

### User Story

En tant que joueur, je veux revoir l’image complète pour mieux résoudre le puzzle.

### Critères d’acceptation

* Le bouton aperçu est visible.
* L’image complète s’affiche clairement.
* Le joueur peut fermer l’aperçu.
* Le puzzle reprend normalement après fermeture.

### Priorité

Should-have.

---

## 9.8 Pause

### Objectif

Permettre au joueur d’arrêter temporairement le jeu.

### Options

* Continuer
* Voir l’image
* Recommencer
* Quitter

### User Story

En tant que joueur, je veux pouvoir mettre le jeu en pause.

### Critères d’acceptation

* Le bouton pause arrête le timer.
* Le joueur peut reprendre la partie.
* Le joueur peut recommencer.
* Le joueur peut quitter sans bug.

### Priorité

Should-have.

---

## 9.9 Détection de victoire

### Objectif

Savoir automatiquement quand le puzzle est terminé.

### Fonctionnement

Chaque pièce possède :

* une position correcte ;
* une position actuelle.

Le puzzle est terminé quand toutes les pièces sont à la bonne position.

### User Story

En tant que joueur, je veux que le jeu reconnaisse automatiquement quand j’ai terminé.

### Critères d’acceptation

* La victoire est détectée correctement.
* L’écran de victoire apparaît automatiquement.
* Le timer s’arrête.
* Le résultat est sauvegardé localement.

### Priorité

Must-have.

---

## 9.10 Écran de victoire

### Objectif

Célébrer la réussite du joueur.

### Éléments

* Photo complète
* Message positif
* Temps final
* Nombre de mouvements
* Bouton “Rejouer”
* Bouton “Nouveau souvenir”
* Bouton “Sauvegarder”

### Messages possibles

* “Souvenir complété.”
* “Bravo, tu as reconstruit ce moment.”
* “Un beau souvenir retrouvé.”
* “Puzzle terminé avec succès.”

### User Story

En tant que joueur, je veux voir ma réussite après avoir terminé le puzzle.

### Critères d’acceptation

* L’écran apparaît après la victoire.
* Le temps final est affiché.
* Les mouvements sont affichés.
* L’utilisateur peut rejouer.
* L’utilisateur peut créer un nouveau puzzle.

### Priorité

Must-have.

---

## 9.11 Mes souvenirs

### Objectif

Permettre à l’utilisateur de retrouver ses puzzles précédents.

### Éléments

* Liste des puzzles joués
* Miniature
* Date
* Difficulté
* Meilleur temps
* Nombre de mouvements
* Bouton rejouer
* Bouton supprimer

### User Story

En tant qu’utilisateur, je veux retrouver les puzzles que j’ai déjà créés.

### Critères d’acceptation

* Les puzzles terminés peuvent apparaître dans l’historique.
* L’utilisateur peut rejouer un puzzle.
* L’utilisateur peut supprimer un souvenir.
* Les données restent locales.

### Priorité

Should-have pour MVP complet.
Could-have pour prototype initial.

---

## 9.12 Paramètres

### Objectif

Permettre à l’utilisateur de personnaliser l’expérience.

### Paramètres MVP

* Langue
* Son activé/désactivé
* Vibration activée/désactivée
* Thème clair/sombre
* Confidentialité
* Supprimer l’historique

### User Story

En tant qu’utilisateur, je veux contrôler les paramètres du jeu.

### Critères d’acceptation

* L’utilisateur peut activer ou désactiver le son.
* L’utilisateur peut activer ou désactiver la vibration.
* L’utilisateur peut supprimer l’historique local.
* L’utilisateur peut lire une information simple sur la confidentialité.

### Priorité

Should-have.

---

# 10. Exigences non fonctionnelles

## 10.1 Performance

* Le puzzle doit se charger rapidement.
* Le jeu doit rester fluide.
* Les images lourdes doivent être optimisées.
* Le jeu ne doit pas consommer trop de mémoire.

## 10.2 Confidentialité

* Les photos restent sur le téléphone.
* Aucun upload automatique.
* Aucun compte obligatoire.
* L’utilisateur peut supprimer l’historique.
* Les permissions doivent être expliquées clairement.

## 10.3 Accessibilité

* Texte lisible.
* Boutons grands et clairs.
* Interface simple.
* Utilisable par enfants et seniors.
* Contrastes suffisants.

## 10.4 Fiabilité

* Le jeu ne doit pas perdre la progression pendant une partie.
* L’application doit gérer les erreurs de permission.
* L’application doit gérer les images non compatibles.
* L’application doit éviter les crashs avec les grandes photos.

---

# 11. Priorisation MVP

## Must-have

Ces éléments sont obligatoires pour la première version :

* Home Screen
* Choix de photo
* Aperçu photo
* Choix de difficulté
* Génération puzzle
* Gameplay drag-and-drop
* Compteur de temps
* Compteur de mouvements
* Détection de victoire
* Écran de victoire
* Confidentialité locale

## Should-have

Ces éléments sont importants, mais peuvent venir juste après le prototype :

* Historique des souvenirs
* Paramètres
* Son
* Vibration
* Pause
* Aperçu image complète
* Miniatures

## Could-have

Ces éléments sont utiles, mais pas prioritaires :

* Thèmes visuels
* Meilleur score par difficulté
* Animation avancée
* Export image de victoire
* Partage simple
* Mode enfant
* Mode senior

## Won’t-have pour MVP

À exclure de la première version :

* Cloud
* Compte utilisateur
* Abonnement
* Publicité
* Multijoueur
* Classement en ligne
* Synchronisation entre appareils
* Boutique
* IA avancée

---

# 12. User Stories principales

## Story 1 — Créer un puzzle

En tant qu’utilisateur,
je veux choisir une photo depuis mon téléphone,
afin de la transformer en puzzle.

## Story 2 — Choisir une difficulté

En tant qu’utilisateur,
je veux choisir un niveau facile, moyen ou difficile,
afin de jouer selon mon niveau.

## Story 3 — Jouer au puzzle

En tant que joueur,
je veux déplacer les pièces avec mon doigt,
afin de reconstruire ma photo.

## Story 4 — Voir l’image originale

En tant que joueur,
je veux voir l’image complète pendant le jeu,
afin de m’aider à résoudre le puzzle.

## Story 5 — Terminer le puzzle

En tant que joueur,
je veux voir un écran de victoire,
afin de savoir que j’ai réussi.

## Story 6 — Rejouer

En tant que joueur,
je veux rejouer le même puzzle,
afin d’améliorer mon temps ou mes mouvements.

## Story 7 — Garder mes souvenirs

En tant qu’utilisateur,
je veux retrouver mes anciens puzzles,
afin de rejouer avec mes souvenirs.

## Story 8 — Supprimer un souvenir

En tant qu’utilisateur,
je veux supprimer un puzzle de mon historique,
afin de garder le contrôle sur mes données.

---

# 13. Parcours utilisateur principal

## Parcours MVP

1. L’utilisateur ouvre l’application.
2. Il appuie sur “Créer un puzzle”.
3. Il choisit une photo.
4. Il voit l’aperçu.
5. Il appuie sur “Continuer”.
6. Il choisit une difficulté.
7. Il appuie sur “Commencer”.
8. Le puzzle est généré.
9. Il déplace les pièces.
10. Il termine le puzzle.
11. L’écran de victoire s’affiche.
12. Il peut rejouer ou créer un nouveau puzzle.

---

# 14. Modèle de données

## PuzzleSession

```text
id
imageReference
thumbnailPath
difficulty
rows
columns
createdAt
lastPlayedAt
isCompleted
bestTimeSeconds
bestMoves
```

## PuzzleResult

```text
id
puzzleSessionId
completedAt
timeSeconds
moves
difficulty
```

## AppSettings

```text
language
soundEnabled
vibrationEnabled
themeMode
privacyAccepted
```

---

# 15. Métriques de succès

## Métriques produit

* Nombre de puzzles créés
* Nombre de puzzles terminés
* Taux de completion
* Nombre moyen de puzzles par utilisateur
* Temps moyen par puzzle
* Nombre de rejoués
* Nombre de puzzles supprimés

## Métriques MVP internes

* L’utilisateur peut créer un puzzle en moins de 30 secondes.
* Le puzzle facile peut être terminé sans difficulté par un débutant.
* L’application ne crash pas avec des photos normales.
* Le gameplay reste fluide.
* L’utilisateur comprend que ses photos restent locales.

---

# 16. Risques produit

## Risque 1 — Le jeu est trop simple

Solution :

* ajouter des niveaux de difficulté ;
* ajouter le meilleur temps ;
* ajouter des animations douces ;
* ajouter un historique émotionnel.

## Risque 2 — Problèmes avec les photos lourdes

Solution :

* redimensionner automatiquement les images ;
* limiter la taille de traitement ;
* générer des miniatures.

## Risque 3 — Inquiétude sur la vie privée

Solution :

* afficher clairement que les photos restent locales ;
* ne pas demander de compte ;
* ne pas envoyer les photos en ligne ;
* ajouter une page confidentialité simple.

## Risque 4 — Gameplay pas assez naturel

Solution :

* tester rapidement le drag-and-drop ;
* améliorer les animations ;
* ajouter un effet de verrouillage léger.

---

# 17. Version 1.0 attendue

La version 1.0 doit être une application Android propre avec :

* une identité visuelle simple ;
* un gameplay stable ;
* trois niveaux de difficulté ;
* une expérience local-first ;
* un historique simple ;
* une page paramètres ;
* une page confidentialité ;
* une icône d’application ;
* une description Play Store.

---

# 18. Définition de “Done”

Le MVP est considéré comme terminé quand :

* l’application s’ouvre correctement ;
* l’utilisateur peut choisir une photo ;
* la photo devient un puzzle ;
* les pièces sont mélangées ;
* le joueur peut déplacer les pièces ;
* le puzzle peut être terminé ;
* l’écran de victoire fonctionne ;
* le temps et les mouvements sont affichés ;
* les données principales sont sauvegardées localement ;
* l’utilisateur peut rejouer ;
* aucune photo n’est envoyée vers un serveur ;
* l’application est testée sur au moins deux appareils Android.

---

# 19. Backlog MVP

## Sprint 1 — Base projet

* Créer projet Flutter
* Créer structure dossiers
* Ajouter navigation
* Créer thème de base
* Créer Home Screen
* Multilangue : Francais et Anglais

## Sprint 2 — Photo Picker

* Ajouter permission galerie
* Choisir une photo
* Afficher aperçu
* Gérer erreur permission
* Continuer vers difficulté

## Sprint 3 — Puzzle Engine

* Charger image
* Redimensionner image
* Découper en grille
* Créer modèle de pièce
* Mélanger pièces

## Sprint 4 — Gameplay

* Afficher grille
* Afficher pièces
* Drag-and-drop
* Échange de positions
* Compter mouvements
* Détecter victoire

## Sprint 5 — Résultat

* Timer
* Écran victoire
* Rejouer
* Nouveau puzzle
* Sauvegarde résultat local

## Sprint 6 — Historique et paramètres

* Liste des souvenirs
* Miniatures
* Rejouer un souvenir
* Supprimer un souvenir
* Paramètres son/vibration
* Page confidentialité

## Sprint 7 — Polish

* Animations
* Sons doux
* Vibration légère
* Design final
* Tests appareils
* Correction bugs

---

# 20. Résumé final

Souvenir Puzzle est un MVP idéal pour démarrer Koyra Games, car il est simple à développer, émotionnellement fort, familial, international et compatible avec une stratégie mobile casual.

Le produit doit rester concentré sur une promesse claire :

> Choisir une photo, la transformer en puzzle, et revivre un souvenir pièce par pièce.

La première version doit privilégier la simplicité, la stabilité, la confidentialité et l’émotion.
