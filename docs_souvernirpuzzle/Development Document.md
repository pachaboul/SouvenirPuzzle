# Souvenir Puzzle — Development Document

Version : 0.1
Projet : Koyra Games
Type : Jeu mobile casual / puzzle photo
Plateformes cibles : Android d’abord, iOS ensuite
Positionnement : Transformez vos photos en puzzles et revivez vos souvenirs pièce par pièce.

---

## 1. Vision du projet

**Souvenir Puzzle** est un jeu mobile simple, familial et émotionnel où l’utilisateur choisit une photo depuis son téléphone, puis l’application transforme cette photo en puzzle jouable.

Le joueur peut utiliser les photos de sa famille, de ses enfants, de ses voyages, de son mariage, de son village, de ses amis ou de moments importants de sa vie.

L’objectif est de créer une expérience calme, propre, accessible et émotionnelle, où chaque puzzle devient une manière de revivre un souvenir personnel.

---

## 2. Objectif stratégique

Souvenir Puzzle est le premier MVP simple et rapide de Koyra Games.

Son rôle stratégique est de :

* tester rapidement la capacité de Koyra Games à publier un jeu mobile ;
* créer un jeu simple avec une forte valeur émotionnelle ;
* viser un public large : familles, enfants, parents, couples, diaspora, seniors ;
* construire une première base technique réutilisable pour d’autres jeux mobiles ;
* commencer avec un produit local-first, sans serveur obligatoire.

---

## 3. Public cible

### Public principal

* Familles
* Parents
* Enfants
* Couples
* Diaspora
* Seniors
* Joueurs casual

### Cas d’usage typiques

* Un parent transforme une photo de son enfant en puzzle.
* Une personne de la diaspora joue avec une photo de son village.
* Un couple transforme une photo de mariage en puzzle.
* Un senior joue calmement avec des photos de famille.
* Un enfant joue avec ses propres photos ou celles de ses proches.

---

## 4. Promesse utilisateur

> “Choisissez une photo. Transformez-la en puzzle. Revivez vos souvenirs pièce par pièce.”

Souvenir Puzzle ne doit pas être seulement un jeu de puzzle.
Il doit être un jeu de mémoire, d’émotion et de simplicité.

---

## 5. Principes de design

### Simplicité

L’utilisateur doit pouvoir créer un puzzle en moins de quelques actions :

1. Ouvrir l’application.
2. Choisir une photo.
3. Sélectionner une difficulté.
4. Jouer.

### Émotion

Le jeu doit mettre la photo au centre de l’expérience.
L’interface ne doit pas voler l’attention du souvenir.

### Accessibilité

Le jeu doit être utilisable par :

* des enfants ;
* des parents ;
* des seniors ;
* des personnes peu habituées aux jeux vidéo.

### Respect de la vie privée

Les photos personnelles sont sensibles.
Pour le MVP, les photos doivent rester sur le téléphone de l’utilisateur.
Aucun compte obligatoire.
Aucun upload obligatoire.
Aucun serveur nécessaire pour jouer.

---

## 6. MVP — Fonctionnalités principales

### 6.1 Choisir une photo

L’utilisateur peut choisir une image depuis la galerie de son téléphone.

Fonctionnalités :

* accès à la galerie ;
* sélection d’une photo ;
* prévisualisation de la photo ;
* possibilité de changer la photo avant de commencer.

---

### 6.2 Transformer la photo en puzzle

L’application découpe automatiquement la photo en pièces.

Difficultés MVP proposées :

* Facile : 3 x 3 pièces
* Moyen : 4 x 4 pièces
* Difficile : 5 x 5 pièces

Pour le premier MVP, il est préférable de commencer avec des pièces carrées ou rectangulaires simples.
Les formes complexes de puzzle peuvent venir plus tard.

---

### 6.3 Jouer au puzzle

Le joueur doit remettre les pièces dans le bon ordre.

Mécanique MVP recommandée :

* les pièces sont mélangées ;
* le joueur déplace les pièces par glisser-déposer ;
* une pièce bien placée peut se verrouiller légèrement ;
* lorsque toutes les pièces sont bien placées, le puzzle est terminé.

---

### 6.4 Écran de victoire

Quand le puzzle est terminé, l’application affiche :

* la photo complète ;
* un message positif ;
* le temps réalisé ;
* le nombre de mouvements ;
* un bouton “Rejouer” ;
* un bouton “Nouveau souvenir”.

Exemples de messages :

* “Souvenir complété.”
* “Bravo, tu as reconstruit ce moment.”
* “Un beau souvenir retrouvé.”
* “Puzzle terminé avec succès.”

---

### 6.5 Historique local

L’application peut garder un historique simple des puzzles joués.

Données possibles :

* nom ou identifiant local de la photo ;
* date de création du puzzle ;
* difficulté ;
* meilleur temps ;
* nombre de mouvements ;
* statut terminé ou non terminé.

Important : pour protéger la vie privée, l’application ne doit pas copier toutes les photos inutilement.
Elle peut garder une référence locale ou une miniature selon les possibilités techniques de la plateforme.

---

## 7. Fonctionnalités non incluses dans le MVP

Ces fonctionnalités sont intéressantes, mais elles ne doivent pas bloquer la première version.

* Compte utilisateur
* Classement en ligne
* Partage social avancé
* Mode multijoueur
* Synchronisation cloud
* Puzzle avec formes réalistes complexes
* Boutique premium
* Publicités
* Albums collaboratifs
* Intelligence artificielle avancée

---

## 8. Écrans principaux

### 8.1 Splash Screen

Objectif : afficher l’identité du jeu.

Contenu :

* logo Souvenir Puzzle ;
* logo ou mention Koyra Games ;
* fond doux, familial et calme.

---

### 8.2 Home Screen

Objectif : permettre à l’utilisateur de commencer rapidement.

Éléments :

* titre : Souvenir Puzzle ;
* slogan court ;
* bouton principal : “Créer un puzzle” ;
* bouton secondaire : “Mes souvenirs” ;
* bouton paramètres.

---

### 8.3 Photo Picker Screen

Objectif : choisir une photo.

Éléments :

* bouton “Choisir une photo” ;
* aperçu de la photo choisie ;
* bouton “Continuer” ;
* message de confidentialité : “Vos photos restent sur votre téléphone.”

---

### 8.4 Difficulty Screen

Objectif : choisir le niveau de difficulté.

Options :

* Facile — 3 x 3
* Moyen — 4 x 4
* Difficile — 5 x 5

Éléments :

* aperçu de la photo ;
* choix du niveau ;
* bouton “Commencer”.

---

### 8.5 Puzzle Game Screen

Objectif : jouer.

Éléments :

* zone de puzzle ;
* compteur de temps ;
* compteur de mouvements ;
* bouton pause ;
* bouton aperçu de l’image complète ;
* bouton recommencer.

---

### 8.6 Pause Screen

Objectif : donner le contrôle au joueur.

Options :

* Continuer ;
* Voir l’image complète ;
* Recommencer ;
* Quitter le puzzle.

---

### 8.7 Victory Screen

Objectif : célébrer la réussite.

Éléments :

* photo complète ;
* message de réussite ;
* temps ;
* mouvements ;
* bouton “Rejouer” ;
* bouton “Nouveau souvenir” ;
* bouton “Sauvegarder dans mes souvenirs”.

---

### 8.8 Memories Screen

Objectif : afficher les puzzles déjà créés ou joués.

Éléments :

* liste des souvenirs ;
* miniature de chaque puzzle ;
* difficulté ;
* meilleur temps ;
* date ;
* bouton rejouer ;
* bouton supprimer.

---

### 8.9 Settings Screen

Objectif : gérer les préférences.

Paramètres MVP :

* langue ;
* son activé/désactivé ;
* vibration activée/désactivée ;
* thème clair/sombre ;
* confidentialité ;
* supprimer l’historique local.

---

## 9. Architecture technique proposée

### Technologie recommandée

Framework : Flutter
Langage : Dart
Stockage local : SQLite ou Hive
Plateformes : Android en premier, iOS ensuite

Flutter est adapté parce qu’il permet de créer rapidement une application mobile propre, fluide et multiplateforme.

---

## 10. Architecture fonctionnelle

Structure possible du projet :

```text
lib/
  main.dart

  app/
    app.dart
    routes.dart
    theme.dart

  features/
    home/
      home_screen.dart

    photo_picker/
      photo_picker_screen.dart
      photo_picker_controller.dart

    difficulty/
      difficulty_screen.dart

    puzzle/
      puzzle_screen.dart
      puzzle_controller.dart
      puzzle_piece.dart
      puzzle_engine.dart

    memories/
      memories_screen.dart
      memories_controller.dart

    settings/
      settings_screen.dart

  data/
    local_database.dart
    puzzle_history_repository.dart

  models/
    puzzle_session.dart
    puzzle_difficulty.dart
    puzzle_result.dart

  shared/
    widgets/
    utils/
```

---

## 11. Modèle de données local

### PuzzleSession

```text
PuzzleSession
- id
- imagePath ou imageReference
- thumbnailPath
- difficulty
- rows
- columns
- createdAt
- lastPlayedAt
- isCompleted
- bestTimeSeconds
- bestMoves
```

### PuzzleResult

```text
PuzzleResult
- id
- puzzleSessionId
- completedAt
- timeSeconds
- moves
- difficulty
```

### PuzzleDifficulty

```text
PuzzleDifficulty
- easy: 3 x 3
- medium: 4 x 4
- hard: 5 x 5
```

---

## 12. Game loop

Le cycle principal du jeu :

1. L’utilisateur choisit une photo.
2. L’application prépare l’image.
3. L’utilisateur choisit une difficulté.
4. L’image est découpée en grille.
5. Les pièces sont mélangées.
6. Le joueur replace les pièces.
7. Le jeu vérifie les positions.
8. Quand tout est correct, le puzzle est terminé.
9. Le résultat est sauvegardé localement.
10. L’écran de victoire est affiché.

---

## 13. Règles de gameplay MVP

### Déplacement des pièces

Le joueur déplace les pièces avec le doigt.

Option recommandée pour MVP :

* drag and drop d’une pièce vers une position ;
* si la pièce est déposée sur une case, elle échange sa position avec la pièce déjà présente.

### Vérification

Chaque pièce possède :

* une position correcte ;
* une position actuelle.

Le puzzle est terminé lorsque toutes les pièces sont à leur position correcte.

### Aide visuelle

Pour garder le jeu accessible :

* bouton pour voir l’image complète ;
* possibilité d’afficher une grille ;
* animation légère quand une pièce est bien placée.

---

## 14. Style visuel

### Ambiance

* calme ;
* propre ;
* familiale ;
* émotionnelle ;
* lumineuse ;
* premium mais simple.

### Couleurs possibles

Palette douce recommandée :

* Bleu nuit doux pour la confiance ;
* Blanc cassé pour la lisibilité ;
* Or doux pour l’émotion et la réussite ;
* Gris clair pour les fonds ;
* Vert doux pour les validations.

### Typographie

Police lisible, ronde et moderne.
Le jeu doit être facile à lire pour les enfants et les seniors.

---

## 15. Son et feedback

Pour le MVP :

* petit son quand une pièce est placée ;
* son doux à la victoire ;
* vibration légère optionnelle ;
* possibilité de désactiver son et vibration.

Le jeu ne doit pas être agressif.
L’ambiance doit rester calme.

---

## 16. Confidentialité

Souvenir Puzzle utilise des photos personnelles.
La confidentialité est donc centrale.

Principes MVP :

* pas de compte obligatoire ;
* pas d’envoi automatique des photos vers un serveur ;
* stockage local uniquement ;
* possibilité de supprimer l’historique ;
* message clair : “Vos photos restent sur votre téléphone.”

---

## 17. Monétisation future

Le MVP peut rester gratuit au départ.

Options futures possibles :

### Version gratuite

* création de puzzles simples ;
* difficultés basiques ;
* historique limité.

### Version premium

* plus de niveaux de difficulté ;
* thèmes visuels ;
* albums de souvenirs ;
* export image du puzzle terminé ;
* pas de publicité ;
* puzzles plus grands ;
* sauvegarde cloud privée.

### Publicité

À éviter au début si l’objectif est une expérience familiale propre.
Si publicité plus tard, elle doit être limitée, non intrusive et adaptée à un public familial.

---

## 18. Roadmap

### Phase 1 — Prototype jouable

Objectif : prouver que la mécanique principale fonctionne.

À faire :

* choisir une photo ;
* découper la photo en grille ;
* mélanger les pièces ;
* déplacer les pièces ;
* détecter la victoire.

---

### Phase 2 — MVP complet

Objectif : créer une première version publiable.

À faire :

* Home Screen ;
* choix de photo ;
* choix de difficulté ;
* écran de jeu ;
* pause ;
* victoire ;
* historique local ;
* paramètres simples ;
* design propre ;
* icône d’application.

---

### Phase 3 — Amélioration utilisateur

Objectif : rendre le jeu plus agréable.

À faire :

* animations ;
* sons doux ;
* vibrations ;
* meilleur système de sauvegarde ;
* miniatures ;
* suppression d’un souvenir ;
* amélioration du design.

---

### Phase 4 — Version publique

Objectif : préparer la publication.

À faire :

* tests Android ;
* correction bugs ;
* optimisation performance ;
* politique de confidentialité ;
* page Play Store ;
* captures d’écran ;
* description marketing ;
* version 1.0.

---

## 19. Critères de réussite du MVP

Le MVP est réussi si :

* l’utilisateur peut choisir une photo depuis son téléphone ;
* l’application transforme la photo en puzzle ;
* le puzzle est jouable sans bug majeur ;
* le joueur peut terminer le puzzle ;
* l’application affiche un écran de victoire ;
* l’historique local fonctionne ;
* aucune photo n’est envoyée en ligne ;
* l’expérience est simple pour un enfant, un parent ou un senior.

---

## 20. Risques techniques

### Gestion des photos

Les photos peuvent être très grandes.
Il faudra réduire ou optimiser l’image avant de créer le puzzle.

### Performance

Le découpage en pièces peut devenir lourd si la grille est trop grande.
Pour le MVP, il faut limiter les difficultés.

### Permissions

L’accès aux photos demande une permission claire selon Android et iOS.

### Vie privée

Il faut éviter toute ambiguïté.
L’utilisateur doit comprendre que ses photos restent locales.

---

## 21. Nom du produit

Nom principal : Souvenir Puzzle
Nom long possible : Souvenir Puzzle — Photo Puzzle Game
Signature : Revivez vos souvenirs pièce par pièce.

---

## 22. Résumé court

Souvenir Puzzle est un jeu mobile familial où l’utilisateur transforme ses propres photos en puzzles. Simple, émotionnel et accessible, il permet de jouer avec les souvenirs de famille, de voyage, de mariage, d’amitié ou de village. Le MVP se concentre sur une expérience locale, privée et rapide : choisir une photo, choisir une difficulté, jouer, terminer et sauvegarder le souvenir.
