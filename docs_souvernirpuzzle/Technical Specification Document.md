# Souvenir Puzzle — Technical Specification Document

Version : 0.1
Projet : Koyra Games
Produit : Souvenir Puzzle
Plateforme MVP : Android
Plateforme future : iOS
Framework recommandé : Flutter
Langage : Dart
Architecture : Local-first / Offline-first
Backend : Aucun pour le MVP

---

# 1. Objectif du document

Ce document définit la structure technique de **Souvenir Puzzle**.

Il explique :

* l’architecture Flutter recommandée ;
* les packages nécessaires ;
* la structure des dossiers ;
* les modèles de données ;
* la logique du moteur de puzzle ;
* la gestion des photos ;
* le stockage local ;
* les permissions Android/iOS ;
* la gestion des erreurs ;
* les tests nécessaires ;
* les règles de performance et confidentialité.

---

# 2. Philosophie technique

Souvenir Puzzle doit être :

* simple à développer ;
* stable ;
* rapide ;
* local-first ;
* respectueux de la vie privée ;
* facile à maintenir ;
* extensible pour de futures versions.

Le MVP ne doit pas dépendre d’un serveur.
Toutes les fonctionnalités principales doivent fonctionner hors ligne.

---

# 3. Stack technique recommandée

## 3.1 Framework

```text
Flutter
```

Pourquoi :

* développement Android et iOS avec une seule base de code ;
* très bon contrôle de l’interface ;
* adapté aux animations ;
* bon choix pour un jeu casual simple ;
* compatible avec une stratégie mobile-first.

## 3.2 Langage

```text
Dart
```

## 3.3 Stockage local

Option recommandée :

```text
sqflite
```

Utilisation :

* historique des puzzles ;
* résultats ;
* meilleurs temps ;
* meilleurs mouvements ;
* paramètres utilisateur.

Alternative plus simple :

```text
Hive
```

Mais pour un projet structuré et durable, `sqflite` est préférable.

## 3.4 Sélection de photo

Package recommandé :

```text
image_picker
```

Utilisation :

* choisir une photo depuis la galerie ;
* éventuellement prendre une photo avec la caméra dans une version future.

## 3.5 Accès aux dossiers locaux

Package recommandé :

```text
path_provider
```

Utilisation :

* stocker les miniatures ;
* stocker les copies optimisées si nécessaire ;
* accéder au dossier local de l’application.

## 3.6 Gestion d’état

Pour le MVP, deux options simples :

```text
Provider
```

ou

```text
Riverpod
```

Recommandation :

```text
Riverpod
```

Pourquoi :

* propre ;
* testable ;
* adapté aux projets qui peuvent grandir ;
* séparation claire entre UI et logique.

## 3.7 Génération des IDs

Package possible :

```text
uuid
```

Utilisation :

* générer les identifiants des sessions ;
* générer les identifiants des résultats.

---

# 4. Packages recommandés

## 4.1 Packages MVP

```yaml
dependencies:
  flutter:
    sdk: flutter

  image_picker:
  path_provider:
  sqflite:
  path:
  flutter_riverpod:
  uuid:
```

## 4.2 Packages optionnels

Pour une version plus avancée :

```yaml
dependencies:
  shared_preferences:
  flutter_animate:
  audioplayers:
  vibration:
```

## 4.3 Règle importante

Ne pas surcharger le MVP avec trop de packages.

Le cœur du jeu doit d’abord fonctionner :

1. choisir une photo ;
2. créer un puzzle ;
3. déplacer les pièces ;
4. détecter la victoire ;
5. sauvegarder le résultat.

---

# 5. Architecture générale

Architecture recommandée :

```text
Feature-first + séparation logique / données / UI
```

Structure :

```text
lib/
  main.dart

  app/
    app.dart
    router.dart
    theme.dart
    constants.dart

  core/
    errors/
      app_exception.dart
    utils/
      image_utils.dart
      time_utils.dart
      id_utils.dart
    widgets/
      primary_button.dart
      secondary_button.dart
      app_card.dart
      confirmation_dialog.dart

  features/
    home/
      presentation/
        home_screen.dart

    photo_picker/
      presentation/
        photo_picker_screen.dart
      application/
        photo_picker_controller.dart

    difficulty/
      presentation/
        difficulty_screen.dart

    puzzle/
      presentation/
        puzzle_screen.dart
        puzzle_board_widget.dart
        puzzle_piece_widget.dart
      application/
        puzzle_controller.dart
        puzzle_timer_controller.dart
      domain/
        puzzle_engine.dart
        puzzle_piece.dart
        puzzle_session.dart
        puzzle_difficulty.dart
        puzzle_result.dart

    memories/
      presentation/
        memories_screen.dart
        memory_card.dart
      application/
        memories_controller.dart

    settings/
      presentation/
        settings_screen.dart
      application/
        settings_controller.dart

  data/
    local/
      app_database.dart
      puzzle_session_dao.dart
      puzzle_result_dao.dart
      settings_dao.dart
    repositories/
      puzzle_repository.dart
      settings_repository.dart
```

---

# 6. Navigation

## 6.1 Routes principales

```text
/
home
photo-picker
difficulty
puzzle
victory
memories
settings
```

## 6.2 Parcours principal

```text
HomeScreen
  ↓
PhotoPickerScreen
  ↓
DifficultyScreen
  ↓
PuzzleScreen
  ↓
VictoryScreen
```

## 6.3 Navigation secondaire

```text
HomeScreen
  ↓
MemoriesScreen

HomeScreen
  ↓
SettingsScreen
```

---

# 7. Modèles de domaine

## 7.1 PuzzleDifficulty

```dart
enum PuzzleDifficulty {
  easy,
  medium,
  hard,
}
```

Mapping :

```dart
extension PuzzleDifficultyConfig on PuzzleDifficulty {
  int get rows {
    switch (this) {
      case PuzzleDifficulty.easy:
        return 3;
      case PuzzleDifficulty.medium:
        return 4;
      case PuzzleDifficulty.hard:
        return 5;
    }
  }

  int get columns {
    switch (this) {
      case PuzzleDifficulty.easy:
        return 3;
      case PuzzleDifficulty.medium:
        return 4;
      case PuzzleDifficulty.hard:
        return 5;
    }
  }

  int get pieceCount => rows * columns;
}
```

---

## 7.2 PuzzlePiece

Chaque pièce doit connaître sa position correcte et sa position actuelle.

```dart
class PuzzlePiece {
  final String id;
  final int correctIndex;
  int currentIndex;

  final int row;
  final int column;

  PuzzlePiece({
    required this.id,
    required this.correctIndex,
    required this.currentIndex,
    required this.row,
    required this.column,
  });

  bool get isCorrectlyPlaced => correctIndex == currentIndex;
}
```

---

## 7.3 PuzzleSession

```dart
class PuzzleSession {
  final String id;
  final String imagePath;
  final String? thumbnailPath;
  final PuzzleDifficulty difficulty;
  final int rows;
  final int columns;
  final DateTime createdAt;

  DateTime? lastPlayedAt;
  bool isCompleted;
  int? bestTimeSeconds;
  int? bestMoves;

  PuzzleSession({
    required this.id,
    required this.imagePath,
    required this.thumbnailPath,
    required this.difficulty,
    required this.rows,
    required this.columns,
    required this.createdAt,
    this.lastPlayedAt,
    this.isCompleted = false,
    this.bestTimeSeconds,
    this.bestMoves,
  });
}
```

---

## 7.4 PuzzleResult

```dart
class PuzzleResult {
  final String id;
  final String puzzleSessionId;
  final DateTime completedAt;
  final int timeSeconds;
  final int moves;
  final PuzzleDifficulty difficulty;

  PuzzleResult({
    required this.id,
    required this.puzzleSessionId,
    required this.completedAt,
    required this.timeSeconds,
    required this.moves,
    required this.difficulty,
  });
}
```

---

## 7.5 AppSettings

```dart
class AppSettings {
  final String language;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String themeMode;
  final bool privacyNoticeSeen;

  AppSettings({
    required this.language,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.themeMode,
    required this.privacyNoticeSeen,
  });
}
```

---

# 8. Base de données locale

## 8.1 Tables nécessaires

Tables MVP :

```text
puzzle_sessions
puzzle_results
app_settings
```

---

## 8.2 Table puzzle_sessions

```sql
CREATE TABLE puzzle_sessions (
  id TEXT PRIMARY KEY,
  image_path TEXT NOT NULL,
  thumbnail_path TEXT,
  difficulty TEXT NOT NULL,
  rows INTEGER NOT NULL,
  columns INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  last_played_at TEXT,
  is_completed INTEGER NOT NULL DEFAULT 0,
  best_time_seconds INTEGER,
  best_moves INTEGER
);
```

---

## 8.3 Table puzzle_results

```sql
CREATE TABLE puzzle_results (
  id TEXT PRIMARY KEY,
  puzzle_session_id TEXT NOT NULL,
  completed_at TEXT NOT NULL,
  time_seconds INTEGER NOT NULL,
  moves INTEGER NOT NULL,
  difficulty TEXT NOT NULL,
  FOREIGN KEY (puzzle_session_id) REFERENCES puzzle_sessions(id)
);
```

---

## 8.4 Table app_settings

```sql
CREATE TABLE app_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

---

# 9. Gestion des photos

## 9.1 Principe de confidentialité

Les photos doivent rester sur le téléphone.

Pour le MVP :

* ne pas envoyer la photo vers un serveur ;
* ne pas créer de compte ;
* ne pas synchroniser les photos ;
* ne pas partager automatiquement les images.

Message à afficher :

```text
Vos photos restent sur votre téléphone.
```

---

## 9.2 Photo originale

Quand l’utilisateur choisit une photo, deux approches sont possibles.

### Option A — Référence locale

L’application garde seulement le chemin local ou la référence du fichier.

Avantages :

* moins de stockage ;
* plus simple ;
* respecte la photo originale.

Limite :

* si la photo est déplacée ou supprimée, le puzzle peut ne plus fonctionner.

### Option B — Copie optimisée dans le dossier de l’application

L’application crée une copie optimisée de la photo dans son dossier local.

Avantages :

* puzzle rejouable même si l’original change ;
* contrôle sur la taille de l’image ;
* meilleure stabilité.

Limite :

* utilise plus de stockage ;
* il faut expliquer que la copie reste locale.

### Recommandation MVP

Utiliser l’Option B.

Créer une copie optimisée locale :

```text
app_documents/souvenir_puzzle/images/session_id.jpg
```

Créer aussi une miniature :

```text
app_documents/souvenir_puzzle/thumbnails/session_id.jpg
```

---

# 10. Optimisation des images

## 10.1 Problème

Les photos modernes peuvent être très lourdes.

Une photo trop grande peut causer :

* lenteur ;
* consommation mémoire ;
* crash ;
* mauvais rendu.

## 10.2 Solution

Avant de créer le puzzle :

* charger l’image ;
* corriger l’orientation si nécessaire ;
* redimensionner l’image ;
* créer une version optimisée ;
* créer une miniature.

## 10.3 Taille recommandée

Pour le MVP :

```text
Image de jeu : maximum 1080 px sur le plus grand côté
Miniature : maximum 300 px sur le plus grand côté
```

## 10.4 Règle de sécurité

Ne jamais manipuler directement une image très lourde dans la grille.

Toujours utiliser une version optimisée pour le puzzle.

---

# 11. Moteur de puzzle

## 11.1 Rôle du PuzzleEngine

Le `PuzzleEngine` est responsable de :

* créer les pièces ;
* attribuer les positions correctes ;
* mélanger les positions ;
* échanger deux pièces ;
* vérifier la victoire.

Il ne doit pas gérer l’interface.

---

## 11.2 Création des pièces

Entrées :

```text
rows
columns
```

Sortie :

```text
List<PuzzlePiece>
```

Pseudo-code :

```dart
List<PuzzlePiece> createPieces({
  required int rows,
  required int columns,
}) {
  final pieces = <PuzzlePiece>[];

  for (int index = 0; index < rows * columns; index++) {
    final row = index ~/ columns;
    final column = index % columns;

    pieces.add(
      PuzzlePiece(
        id: 'piece_$index',
        correctIndex: index,
        currentIndex: index,
        row: row,
        column: column,
      ),
    );
  }

  return pieces;
}
```

---

## 11.3 Mélange des pièces

Objectif :

* changer les positions actuelles ;
* éviter que le puzzle soit déjà résolu.

Pseudo-code :

```dart
List<PuzzlePiece> shufflePieces(List<PuzzlePiece> pieces) {
  final indexes = pieces.map((piece) => piece.correctIndex).toList();

  do {
    indexes.shuffle();
  } while (_isAlreadySolved(indexes));

  for (int i = 0; i < pieces.length; i++) {
    pieces[i].currentIndex = indexes[i];
  }

  return pieces;
}

bool _isAlreadySolved(List<int> indexes) {
  for (int i = 0; i < indexes.length; i++) {
    if (indexes[i] != i) {
      return false;
    }
  }
  return true;
}
```

Important :

Pour ce type de puzzle avec échange libre de pièces, il n’y a pas le même problème de solvabilité qu’un sliding puzzle classique.
Comme le joueur peut échanger n’importe quelles pièces, tout mélange est résoluble tant que toutes les pièces existent.

---

## 11.4 Échange de pièces

Quand le joueur dépose une pièce sur une autre case :

```dart
void swapPieces({
  required PuzzlePiece first,
  required PuzzlePiece second,
}) {
  final temp = first.currentIndex;
  first.currentIndex = second.currentIndex;
  second.currentIndex = temp;
}
```

Après l’échange :

1. augmenter le compteur de mouvements ;
2. vérifier la victoire ;
3. mettre à jour l’interface.

---

## 11.5 Vérification de victoire

```dart
bool isCompleted(List<PuzzlePiece> pieces) {
  return pieces.every((piece) => piece.isCorrectlyPlaced);
}
```

Quand `isCompleted` retourne `true` :

```text
stop timer
save result
update best score
show victory screen
```

---

# 12. Affichage des pièces

## 12.1 Méthode recommandée MVP

Ne pas forcément créer physiquement plusieurs fichiers image.

Pour le MVP, on peut afficher la même image complète dans chaque pièce, mais avec un recadrage différent.

Chaque pièce utilise :

* la photo optimisée ;
* son `correctIndex` ;
* sa position dans la grille ;
* un `ClipRect` ou une logique de découpage visuel.

Avantage :

* moins de fichiers ;
* moins de stockage ;
* plus rapide à gérer ;
* logique plus propre.

## 12.2 Calcul de la zone d’une pièce

Pour une grille :

```text
rows = 3
columns = 3
```

Chaque pièce représente :

```text
pieceWidth = imageWidth / columns
pieceHeight = imageHeight / rows
```

Pour une pièce à la ligne `row` et colonne `column` :

```text
cropX = column * pieceWidth
cropY = row * pieceHeight
```

---

# 13. PuzzleController

## 13.1 Responsabilités

Le `PuzzleController` gère l’état de la partie.

Il doit contenir :

* session actuelle ;
* liste des pièces ;
* temps écoulé ;
* nombre de mouvements ;
* état du jeu ;
* logique de pause ;
* logique de victoire.

## 13.2 États possibles

```dart
enum PuzzleGameState {
  idle,
  generating,
  playing,
  paused,
  completed,
  error,
}
```

## 13.3 Actions principales

```text
startPuzzle()
pausePuzzle()
resumePuzzle()
restartPuzzle()
swapPiece()
showPreview()
completePuzzle()
exitPuzzle()
```

---

# 14. Timer

## 14.1 Règles

Le timer :

* commence quand le puzzle est affiché ;
* continue pendant le jeu ;
* s’arrête pendant la pause ;
* s’arrête à la victoire ;
* se remet à zéro si le joueur recommence.

## 14.2 Format

```text
00:45
02:31
10:08
```

## 14.3 Implémentation

Utiliser un `Timer.periodic` ou un `Ticker`.

Pour le MVP, `Timer.periodic` est suffisant.

---

# 15. Drag-and-drop

## 15.1 Mécanique MVP

L’utilisateur glisse une pièce vers une autre case.

Quand il relâche :

* si la cible est valide, les deux pièces échangent leur position ;
* sinon, la pièce retourne à sa place ;
* le compteur de mouvements augmente seulement si l’échange est valide.

## 15.2 Widgets Flutter possibles

Utiliser :

```text
Draggable
DragTarget
```

ou une solution personnalisée avec :

```text
GestureDetector
AnimatedPositioned
Stack
```

## 15.3 Recommandation MVP

Commencer avec :

```text
Draggable + DragTarget
```

C’est plus simple pour une première version.

Passer à une solution personnalisée seulement si le comportement n’est pas assez fluide.

---

# 16. Sauvegarde des résultats

## 16.1 Quand sauvegarder ?

Sauvegarder quand le puzzle est terminé.

Données à sauvegarder :

```text
puzzleSessionId
completedAt
timeSeconds
moves
difficulty
```

## 16.2 Mise à jour des meilleurs scores

Lorsqu’un puzzle est terminé :

```text
si bestTimeSeconds est null → sauvegarder le temps
sinon si timeSeconds < bestTimeSeconds → mettre à jour

si bestMoves est null → sauvegarder les mouvements
sinon si moves < bestMoves → mettre à jour
```

---

# 17. Historique “Mes souvenirs”

## 17.1 Données affichées

Pour chaque souvenir :

* miniature ;
* difficulté ;
* meilleur temps ;
* meilleur nombre de mouvements ;
* date de création ;
* date de dernière partie.

## 17.2 Actions possibles

* rejouer ;
* supprimer.

## 17.3 Suppression

Quand l’utilisateur supprime un souvenir :

* supprimer la session de la base locale ;
* supprimer les résultats liés ;
* supprimer la miniature ;
* supprimer la copie optimisée de l’image si elle existe ;
* ne jamais supprimer la photo originale de la galerie.

Message :

```text
Vos photos originales ne seront pas supprimées de votre téléphone.
```

---

# 18. Paramètres

## 18.1 Paramètres MVP

```text
soundEnabled
vibrationEnabled
themeMode
language
privacyNoticeSeen
```

## 18.2 Valeurs par défaut

```text
soundEnabled = true
vibrationEnabled = true
themeMode = light
language = system
privacyNoticeSeen = false
```

---

# 19. Permissions Android

## 19.1 Objectif

L’application doit accéder aux photos uniquement pour permettre à l’utilisateur de choisir une image.

## 19.2 Règles

L’app ne doit demander que les permissions nécessaires.

Pour le MVP :

* demander l’accès via le sélecteur de photos ;
* ne pas demander plus que nécessaire ;
* expliquer simplement pourquoi l’accès est demandé.

Texte recommandé :

```text
Souvenir Puzzle utilise cette photo uniquement pour créer votre puzzle sur votre téléphone.
```

## 19.3 Cas d’erreur

Si l’accès est refusé :

```text
Impossible d’accéder aux photos.
Vous pouvez autoriser l’accès depuis les paramètres de votre téléphone.
```

---

# 20. Permissions iOS

## 20.1 Objectif

Même logique que sur Android :

* accès à la galerie uniquement pour choisir une photo ;
* pas de téléversement ;
* traitement local.

## 20.2 Texte Info.plist recommandé

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Souvenir Puzzle utilise vos photos uniquement pour créer des puzzles sur votre téléphone.</string>
```

Si la caméra est ajoutée plus tard :

```xml
<key>NSCameraUsageDescription</key>
<string>Souvenir Puzzle utilise la caméra uniquement si vous voulez prendre une photo pour créer un puzzle.</string>
```

---

# 21. Gestion des erreurs

## 21.1 Types d’erreurs

```text
permissionDenied
imageNotFound
imageTooLarge
imageDecodeFailed
databaseError
unknownError
```

## 21.2 AppException

```dart
class AppException implements Exception {
  final String code;
  final String message;

  AppException({
    required this.code,
    required this.message,
  });
}
```

## 21.3 Messages utilisateur

Permission refusée :

```text
Impossible d’accéder aux photos.
Vous pouvez autoriser l’accès depuis les paramètres de votre téléphone.
```

Image non compatible :

```text
Cette image ne peut pas être utilisée.
Essayez avec une autre photo.
```

Erreur inconnue :

```text
Une erreur est survenue.
Veuillez réessayer.
```

---

# 22. Performance

## 22.1 Objectifs

L’application doit :

* s’ouvrir rapidement ;
* générer le puzzle sans longue attente ;
* rester fluide pendant le drag-and-drop ;
* éviter les crashs mémoire ;
* fonctionner sur des téléphones Android moyens.

## 22.2 Bonnes pratiques

* redimensionner les images ;
* éviter de créer trop de fichiers ;
* éviter les grilles trop grandes dans le MVP ;
* utiliser des widgets légers ;
* éviter les animations lourdes ;
* tester sur un appareil Android réel.

## 22.3 Limites MVP

Ne pas dépasser :

```text
5 x 5 = 25 pièces
```

Les niveaux plus grands peuvent venir plus tard.

---

# 23. Sécurité et confidentialité

## 23.1 Règles

Pour le MVP :

* pas de serveur ;
* pas de compte ;
* pas de cloud ;
* pas de tracking personnel ;
* pas d’upload automatique ;
* stockage local uniquement.

## 23.2 Données stockées

L’application peut stocker :

* copie optimisée locale ;
* miniature locale ;
* difficulté ;
* temps ;
* mouvements ;
* date de création ;
* date de dernière partie.

## 23.3 Données non stockées

L’application ne doit pas stocker :

* localisation GPS ;
* contacts ;
* données personnelles inutiles ;
* compte utilisateur ;
* données cloud.

---

# 24. Tests

## 24.1 Tests unitaires

À tester :

* création des pièces ;
* mélange des pièces ;
* échange de pièces ;
* détection de victoire ;
* calcul difficulté ;
* mise à jour meilleur temps ;
* mise à jour meilleur nombre de mouvements.

## 24.2 Tests widgets

À tester :

* Home Screen ;
* Difficulty Screen ;
* Puzzle Board ;
* Victory Screen ;
* Memories Screen.

## 24.3 Tests manuels

Scénarios :

```text
Créer un puzzle facile
Créer un puzzle moyen
Créer un puzzle difficile
Refuser permission photo
Choisir une photo lourde
Terminer un puzzle
Rejouer un puzzle
Supprimer un souvenir
Désactiver son
Désactiver vibration
```

---

# 25. Critères techniques de validation

Le MVP technique est validé si :

* l’application s’installe sur Android ;
* l’utilisateur peut choisir une photo ;
* la photo est optimisée localement ;
* la photo est transformée en puzzle ;
* les pièces sont mélangées ;
* le joueur peut échanger les pièces ;
* le timer fonctionne ;
* le compteur de mouvements fonctionne ;
* la victoire est détectée ;
* le résultat est sauvegardé localement ;
* l’historique affiche le puzzle ;
* la suppression fonctionne ;
* aucune photo n’est envoyée en ligne ;
* l’application ne crash pas sur des photos normales.

---

# 26. Ordre de développement recommandé

## Étape 1 — Setup projet

* Créer projet Flutter.
* Créer structure de dossiers.
* Ajouter thème.
* Ajouter navigation.
* Créer Home Screen.

## Étape 2 — Photo Picker

* Ajouter `image_picker`.
* Choisir une photo.
* Afficher aperçu.
* Gérer permission refusée.
* Créer copie optimisée locale.

## Étape 3 — Puzzle Engine

* Créer `PuzzleDifficulty`.
* Créer `PuzzlePiece`.
* Créer `PuzzleEngine`.
* Générer pièces.
* Mélanger positions.
* Tester victoire.

## Étape 4 — Puzzle UI

* Afficher grille.
* Afficher pièces.
* Ajouter drag-and-drop.
* Échanger pièces.
* Ajouter mouvements.
* Ajouter timer.

## Étape 5 — Victory

* Détecter puzzle terminé.
* Arrêter timer.
* Afficher écran de victoire.
* Rejouer.
* Nouveau souvenir.

## Étape 6 — Stockage local

* Ajouter `sqflite`.
* Créer tables.
* Sauvegarder session.
* Sauvegarder résultat.
* Afficher historique.

## Étape 7 — Paramètres

* Son.
* Vibration.
* Thème.
* Confidentialité.
* Suppression historique.

## Étape 8 — Polish

* Animations.
* Sons doux.
* Vibration légère.
* Correction bugs.
* Tests appareils.
* Optimisation performance.

---

# 27. Prototype minimal absolu

Si l’objectif est de construire très vite, le prototype minimal peut se limiter à :

```text
1. Choisir une photo
2. Choisir 3 x 3
3. Afficher puzzle
4. Échanger les pièces
5. Détecter victoire
6. Afficher message “Souvenir complété”
```

Ce prototype peut être fait avant l’historique, les paramètres et les sons.

---

# 28. Version MVP complète

La version MVP complète doit inclure :

```text
1. Home Screen
2. Photo Picker
3. Difficulty Screen
4. Puzzle 3 x 3, 4 x 4, 5 x 5
5. Timer
6. Mouvements
7. Preview image
8. Pause
9. Victory Screen
10. Historique local
11. Paramètres simples
12. Confidentialité locale
```

---

# 29. Structure future possible

## 29.1 Version 1.1

* mode sombre ;
* sons améliorés ;
* meilleures animations ;
* sauvegarde des puzzles non terminés.

## 29.2 Version 1.2

* mode enfant ;
* mode senior ;
* nouvelles difficultés ;
* badges doux.

## 29.3 Version 2.0

* albums ;
* partage optionnel ;
* cloud privé optionnel ;
* puzzles familiaux collaboratifs.

---

# 30. Résumé technique

Souvenir Puzzle doit commencer comme une application Flutter simple, locale et stable.

Le cœur technique est composé de cinq blocs :

```text
Photo Picker
Puzzle Engine
Puzzle UI
Local Storage
Privacy-first UX
```

La priorité est de construire rapidement un MVP jouable, puis d’améliorer l’expérience.

Le principe le plus important :

> La photo appartient à l’utilisateur. Le puzzle est créé localement. Le souvenir reste privé.
