# Souvenir Puzzle — Flutter Project Structure & Implementation Plan

Version : 0.1
Projet : Koyra Games
Produit : Souvenir Puzzle
Framework : Flutter
Langage : Dart
Architecture : Feature-first / Local-first
Backend MVP : Aucun

---

# 1. Objectif du document

Ce document définit comment organiser et développer le projet Flutter **Souvenir Puzzle**.

Il couvre :

* la structure exacte du projet ;
* les dossiers à créer ;
* les fichiers principaux ;
* les responsabilités de chaque couche ;
* les services nécessaires ;
* les controllers ;
* les widgets réutilisables ;
* l’ordre de développement ;
* les tâches MVP ;
* les critères de validation.

---

# 2. Philosophie d’implémentation

Souvenir Puzzle doit être développé avec une approche simple, propre et progressive.

Les priorités techniques sont :

1. créer rapidement un prototype jouable ;
2. garder une architecture claire ;
3. séparer l’interface, la logique de jeu et les données ;
4. éviter de complexifier le MVP ;
5. protéger les photos de l’utilisateur ;
6. préparer l’application pour une future version iOS.

---

# 3. Architecture recommandée

Architecture choisie :

```text
Feature-first architecture
```

Chaque grande fonctionnalité possède son propre dossier.

Exemple :

```text
home/
photo_picker/
difficulty/
puzzle/
memories/
settings/
```

Cette approche rend le projet plus facile à comprendre et à faire évoluer.

---

# 4. Structure globale du projet

```text
souvenir_puzzle/
  android/
  ios/
  assets/
    images/
    icons/
    sounds/
    fonts/

  lib/
    main.dart

    app/
      app.dart
      router.dart
      theme.dart
      app_constants.dart

    core/
      errors/
        app_exception.dart

      utils/
        image_utils.dart
        time_utils.dart
        file_utils.dart
        id_utils.dart

      widgets/
        primary_button.dart
        secondary_button.dart
        app_card.dart
        app_scaffold.dart
        confirmation_dialog.dart
        empty_state_widget.dart
        loading_widget.dart

      services/
        file_storage_service.dart
        image_processing_service.dart
        permission_service.dart
        sound_service.dart
        vibration_service.dart

    data/
      local/
        app_database.dart
        database_tables.dart
        puzzle_session_dao.dart
        puzzle_result_dao.dart
        settings_dao.dart

      models/
        puzzle_session_model.dart
        puzzle_result_model.dart
        app_setting_model.dart

      repositories/
        puzzle_repository.dart
        settings_repository.dart

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
        domain/
          puzzle_difficulty.dart
          puzzle_piece.dart
          puzzle_session.dart
          puzzle_result.dart
          puzzle_engine.dart
          puzzle_game_state.dart

        application/
          puzzle_controller.dart
          puzzle_timer_controller.dart

        presentation/
          puzzle_screen.dart
          puzzle_board_widget.dart
          puzzle_piece_widget.dart
          image_preview_modal.dart
          pause_dialog.dart
          victory_screen.dart

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
```

---

# 5. Dossiers principaux

## 5.1 `app/`

Contient la configuration globale de l’application.

Responsabilités :

* point d’entrée visuel ;
* navigation ;
* thème ;
* constantes globales.

Fichiers :

```text
app.dart
router.dart
theme.dart
app_constants.dart
```

---

## 5.2 `core/`

Contient les éléments réutilisables dans toute l’application.

Responsabilités :

* widgets communs ;
* services techniques ;
* utilitaires ;
* gestion d’erreurs.

Ce dossier ne doit pas dépendre d’une fonctionnalité spécifique.

---

## 5.3 `data/`

Contient la couche de données.

Responsabilités :

* base SQLite ;
* modèles de données ;
* DAO ;
* repositories ;
* sauvegarde locale.

---

## 5.4 `features/`

Contient les fonctionnalités principales du produit.

Chaque feature est séparée :

* `home`
* `photo_picker`
* `difficulty`
* `puzzle`
* `memories`
* `settings`

---

# 6. Fichier `main.dart`

Rôle :

* initialiser Flutter ;
* initialiser les dépendances ;
* lancer l’application.

Structure recommandée :

```dart
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SouvenirPuzzleApp());
}
```

---

# 7. Fichier `app.dart`

Rôle :

* définir l’application principale ;
* charger le thème ;
* connecter le router.

Exemple :

```dart
import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class SouvenirPuzzleApp extends StatelessWidget {
  const SouvenirPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Souvenir Puzzle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.home,
      routes: AppRouter.routes,
    );
  }
}
```

---

# 8. Fichier `router.dart`

Rôle :

* centraliser les routes ;
* éviter d’éparpiller les noms d’écrans.

Routes MVP :

```dart
import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/photo_picker/presentation/photo_picker_screen.dart';
import '../features/difficulty/presentation/difficulty_screen.dart';
import '../features/puzzle/presentation/puzzle_screen.dart';
import '../features/puzzle/presentation/victory_screen.dart';
import '../features/memories/presentation/memories_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String photoPicker = '/photo-picker';
  static const String difficulty = '/difficulty';
  static const String puzzle = '/puzzle';
  static const String victory = '/victory';
  static const String memories = '/memories';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (_) => const HomeScreen(),
      photoPicker: (_) => const PhotoPickerScreen(),
      difficulty: (_) => const DifficultyScreen(),
      puzzle: (_) => const PuzzleScreen(),
      victory: (_) => const VictoryScreen(),
      memories: (_) => const MemoriesScreen(),
      settings: (_) => const SettingsScreen(),
    };
  }
}
```

---

# 9. Fichier `theme.dart`

Rôle :

* définir les couleurs ;
* définir les styles de texte ;
* définir les boutons ;
* garder une identité visuelle cohérente.

Couleurs recommandées :

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color souvenirBlue = Color(0xFF1E3A5F);
  static const Color softCream = Color(0xFFFFF8EE);
  static const Color memoryGold = Color(0xFFE8B04A);
  static const Color successGreen = Color(0xFF4CAF7D);
  static const Color textDark = Color(0xFF2E2E2E);
  static const Color textMuted = Color(0xFF8A8A8A);
  static const Color white = Color(0xFFFFFFFF);
}
```

Thème clair :

```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.softCream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.souvenirBlue,
        primary: AppColors.souvenirBlue,
        secondary: AppColors.memoryGold,
      ),
      fontFamily: 'Nunito',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.softCream,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
```

---

# 10. Assets

## 10.1 Structure

```text
assets/
  images/
    logo.png
    empty_memories.png

  icons/
    puzzle_piece.png
    gallery.png
    settings.png

  sounds/
    piece_move.mp3
    piece_success.mp3
    victory.mp3

  fonts/
    Nunito-Regular.ttf
    Nunito-Bold.ttf
```

---

## 10.2 Configuration `pubspec.yaml`

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/sounds/

  fonts:
    - family: Nunito
      fonts:
        - asset: assets/fonts/Nunito-Regular.ttf
        - asset: assets/fonts/Nunito-Bold.ttf
          weight: 700
```

Pour le MVP, les sons et polices personnalisées peuvent être ajoutés après le prototype jouable.

---

# 11. Dépendances recommandées

Dans `pubspec.yaml` :

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

Dépendances optionnelles :

```yaml
dependencies:
  shared_preferences:
  audioplayers:
  vibration:
```

Pour commencer vite, on peut d’abord utiliser :

```yaml
dependencies:
  image_picker:
  path_provider:
  uuid:
```

Puis ajouter SQLite après le prototype de gameplay.

---

# 12. Couche domaine du puzzle

Le domaine contient la logique pure du jeu.

Dossier :

```text
features/puzzle/domain/
```

Fichiers :

```text
puzzle_difficulty.dart
puzzle_piece.dart
puzzle_session.dart
puzzle_result.dart
puzzle_engine.dart
puzzle_game_state.dart
```

---

## 12.1 `puzzle_difficulty.dart`

```dart
enum PuzzleDifficulty {
  easy,
  medium,
  hard,
}

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

  String get label {
    switch (this) {
      case PuzzleDifficulty.easy:
        return 'Facile';
      case PuzzleDifficulty.medium:
        return 'Moyen';
      case PuzzleDifficulty.hard:
        return 'Difficile';
    }
  }
}
```

---

## 12.2 `puzzle_piece.dart`

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

  PuzzlePiece copyWith({
    String? id,
    int? correctIndex,
    int? currentIndex,
    int? row,
    int? column,
  }) {
    return PuzzlePiece(
      id: id ?? this.id,
      correctIndex: correctIndex ?? this.correctIndex,
      currentIndex: currentIndex ?? this.currentIndex,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }
}
```

---

## 12.3 `puzzle_game_state.dart`

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

---

## 12.4 `puzzle_engine.dart`

```dart
import 'puzzle_piece.dart';

class PuzzleEngine {
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

  List<PuzzlePiece> shufflePieces(List<PuzzlePiece> pieces) {
    final currentIndexes = pieces.map((piece) => piece.correctIndex).toList();

    do {
      currentIndexes.shuffle();
    } while (_isAlreadySolved(currentIndexes));

    return [
      for (int i = 0; i < pieces.length; i++)
        pieces[i].copyWith(currentIndex: currentIndexes[i])
    ];
  }

  List<PuzzlePiece> swapPieces({
    required List<PuzzlePiece> pieces,
    required int firstCurrentIndex,
    required int secondCurrentIndex,
  }) {
    final updatedPieces = pieces.map((piece) => piece.copyWith()).toList();

    final firstPiece = updatedPieces.firstWhere(
      (piece) => piece.currentIndex == firstCurrentIndex,
    );

    final secondPiece = updatedPieces.firstWhere(
      (piece) => piece.currentIndex == secondCurrentIndex,
    );

    final temp = firstPiece.currentIndex;
    firstPiece.currentIndex = secondPiece.currentIndex;
    secondPiece.currentIndex = temp;

    return updatedPieces;
  }

  bool isCompleted(List<PuzzlePiece> pieces) {
    return pieces.every((piece) => piece.isCorrectlyPlaced);
  }

  bool _isAlreadySolved(List<int> indexes) {
    for (int i = 0; i < indexes.length; i++) {
      if (indexes[i] != i) return false;
    }
    return true;
  }
}
```

---

# 13. Couche application

La couche application contrôle les états.

Dossier :

```text
features/puzzle/application/
```

Fichiers :

```text
puzzle_controller.dart
puzzle_timer_controller.dart
```

---

## 13.1 `puzzle_controller.dart`

Responsabilités :

* initialiser la partie ;
* gérer les pièces ;
* gérer les mouvements ;
* gérer la pause ;
* vérifier la victoire ;
* envoyer le joueur vers l’écran de victoire.

Structure simple :

```dart
import '../domain/puzzle_difficulty.dart';
import '../domain/puzzle_engine.dart';
import '../domain/puzzle_game_state.dart';
import '../domain/puzzle_piece.dart';

class PuzzleController {
  final PuzzleEngine engine;

  PuzzleController({
    required this.engine,
  });

  PuzzleGameState state = PuzzleGameState.idle;
  List<PuzzlePiece> pieces = [];
  int moves = 0;
  PuzzleDifficulty? difficulty;

  void start(PuzzleDifficulty selectedDifficulty) {
    state = PuzzleGameState.generating;
    difficulty = selectedDifficulty;

    final createdPieces = engine.createPieces(
      rows: selectedDifficulty.rows,
      columns: selectedDifficulty.columns,
    );

    pieces = engine.shufflePieces(createdPieces);
    moves = 0;
    state = PuzzleGameState.playing;
  }

  bool swap({
    required int firstCurrentIndex,
    required int secondCurrentIndex,
  }) {
    if (state != PuzzleGameState.playing) return false;
    if (firstCurrentIndex == secondCurrentIndex) return false;

    pieces = engine.swapPieces(
      pieces: pieces,
      firstCurrentIndex: firstCurrentIndex,
      secondCurrentIndex: secondCurrentIndex,
    );

    moves++;

    final completed = engine.isCompleted(pieces);
    if (completed) {
      state = PuzzleGameState.completed;
    }

    return completed;
  }

  void pause() {
    if (state == PuzzleGameState.playing) {
      state = PuzzleGameState.paused;
    }
  }

  void resume() {
    if (state == PuzzleGameState.paused) {
      state = PuzzleGameState.playing;
    }
  }

  void restart() {
    final currentDifficulty = difficulty;
    if (currentDifficulty == null) return;

    start(currentDifficulty);
  }
}
```

Plus tard, ce controller doit être transformé en `StateNotifier` ou `Notifier` avec Riverpod.

---

## 13.2 `puzzle_timer_controller.dart`

Responsabilités :

* démarrer le timer ;
* arrêter le timer ;
* mettre en pause ;
* reprendre ;
* réinitialiser.

Structure :

```dart
import 'dart:async';

class PuzzleTimerController {
  Timer? _timer;
  int elapsedSeconds = 0;
  bool isRunning = false;

  void start() {
    stop();
    elapsedSeconds = 0;
    isRunning = true;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        elapsedSeconds++;
      },
    );
  }

  void pause() {
    _timer?.cancel();
    isRunning = false;
  }

  void resume() {
    if (isRunning) return;

    isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        elapsedSeconds++;
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
  }

  void reset() {
    stop();
    elapsedSeconds = 0;
  }

  void dispose() {
    stop();
  }
}
```

---

# 14. Photo Picker Feature

Dossier :

```text
features/photo_picker/
```

Fichiers :

```text
presentation/photo_picker_screen.dart
application/photo_picker_controller.dart
```

---

## 14.1 Responsabilités

Cette feature doit :

* ouvrir la galerie ;
* permettre de choisir une photo ;
* afficher l’aperçu ;
* gérer permission refusée ;
* envoyer la photo choisie vers l’écran de difficulté.

---

## 14.2 `photo_picker_controller.dart`

Responsabilités :

* appeler `image_picker` ;
* stocker temporairement l’image choisie ;
* gérer les erreurs.

Pseudo-structure :

```dart
class PhotoPickerController {
  String? selectedImagePath;
  String? errorMessage;

  Future<void> pickImage() async {
    // 1. ouvrir galerie
    // 2. récupérer image
    // 3. sauvegarder path
    // 4. gérer erreurs
  }

  void clearImage() {
    selectedImagePath = null;
    errorMessage = null;
  }
}
```

---

# 15. Image Processing Service

Dossier :

```text
core/services/
```

Fichier :

```text
image_processing_service.dart
```

---

## 15.1 Responsabilités

Le service doit :

* recevoir le chemin de l’image sélectionnée ;
* redimensionner l’image ;
* corriger l’orientation si nécessaire ;
* créer une copie optimisée ;
* créer une miniature.

---

## 15.2 Fonctions

```text
optimizeImage
createThumbnail
getImageSize
validateImage
```

---

## 15.3 Règle MVP

Pour aller vite, la première version peut utiliser directement l’image sélectionnée.
Mais avant publication, il faut ajouter l’optimisation pour éviter les crashs avec les photos lourdes.

---

# 16. File Storage Service

Dossier :

```text
core/services/
```

Fichier :

```text
file_storage_service.dart
```

---

## 16.1 Responsabilités

Ce service gère les fichiers locaux.

Fonctions :

```text
getAppImagesDirectory
getAppThumbnailsDirectory
saveImageCopy
saveThumbnail
deleteFile
deleteMemoryFiles
deleteAllMemoryFiles
```

---

## 16.2 Chemins recommandés

```text
app_documents/souvenir_puzzle/images/{session_id}.jpg
app_documents/souvenir_puzzle/thumbnails/{session_id}.jpg
```

---

# 17. Puzzle UI

Dossier :

```text
features/puzzle/presentation/
```

Fichiers :

```text
puzzle_screen.dart
puzzle_board_widget.dart
puzzle_piece_widget.dart
image_preview_modal.dart
pause_dialog.dart
victory_screen.dart
```

---

## 17.1 `puzzle_screen.dart`

Responsabilités :

* afficher le timer ;
* afficher les mouvements ;
* afficher le puzzle board ;
* gérer pause ;
* gérer aperçu ;
* détecter la victoire ;
* naviguer vers Victory Screen.

Structure UI :

```text
[Pause]       01:24       18 mouvements

[PuzzleBoardWidget]

[Aperçu]   [Recommencer]
```

---

## 17.2 `puzzle_board_widget.dart`

Responsabilités :

* afficher la grille ;
* afficher les pièces ;
* gérer les zones de drag-and-drop.

Paramètres :

```dart
class PuzzleBoardWidget extends StatelessWidget {
  final String imagePath;
  final int rows;
  final int columns;
  final List<PuzzlePiece> pieces;
  final void Function(int fromIndex, int toIndex) onSwap;

  const PuzzleBoardWidget({
    super.key,
    required this.imagePath,
    required this.rows,
    required this.columns,
    required this.pieces,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    // Build GridView or custom grid
    return const SizedBox();
  }
}
```

---

## 17.3 `puzzle_piece_widget.dart`

Responsabilités :

* afficher une pièce ;
* utiliser le bon crop de l’image ;
* permettre le drag.

Paramètres :

```dart
class PuzzlePieceWidget extends StatelessWidget {
  final String imagePath;
  final PuzzlePiece piece;
  final int rows;
  final int columns;

  const PuzzlePieceWidget({
    super.key,
    required this.imagePath,
    required this.piece,
    required this.rows,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    // Afficher le crop visuel de l’image.
    return const SizedBox();
  }
}
```

---

# 18. Affichage du crop de l’image

Pour le MVP, il y a deux solutions.

## 18.1 Solution simple

Créer physiquement chaque pièce comme une petite image.

Avantages :

* plus facile à afficher ;
* moins de calcul UI.

Inconvénients :

* plus de fichiers ;
* stockage plus lourd ;
* moins élégant.

---

## 18.2 Solution recommandée

Afficher la même image dans chaque pièce avec un alignement différent.

Principe :

* chaque pièce affiche l’image complète ;
* l’image est agrandie à la taille complète du puzzle ;
* le widget montre seulement la zone correspondant à la pièce.

Cette solution est plus propre, mais demande plus de précision.

---

# 19. Memories Feature

Dossier :

```text
features/memories/
```

Fichiers :

```text
presentation/memories_screen.dart
presentation/memory_card.dart
application/memories_controller.dart
```

---

## 19.1 Responsabilités

Cette feature affiche les puzzles déjà créés.

Fonctions :

* lister les souvenirs ;
* rejouer un souvenir ;
* supprimer un souvenir ;
* afficher l’état vide.

---

## 19.2 `memories_screen.dart`

État vide :

```text
Aucun souvenir pour le moment.
Créez votre premier puzzle avec une photo importante.
```

Carte souvenir :

```text
[Miniature]
Facile — 9 pièces
Meilleur temps : 01:34
Joué le : 16 juin 2026
[Rejouer]
[Supprimer]
```

---

# 20. Settings Feature

Dossier :

```text
features/settings/
```

Fichiers :

```text
presentation/settings_screen.dart
application/settings_controller.dart
```

---

## 20.1 Responsabilités

Paramètres MVP :

* son activé/désactivé ;
* vibration activée/désactivée ;
* thème ;
* confidentialité ;
* suppression de l’historique.

---

## 20.2 Texte confidentialité

```text
Souvenir Puzzle ne téléverse pas vos photos.
Les puzzles sont créés directement sur votre téléphone.
```

---

# 21. Widgets communs

Dossier :

```text
core/widgets/
```

---

## 21.1 `primary_button.dart`

Utilisation :

* créer puzzle ;
* continuer ;
* commencer ;
* nouveau souvenir.

---

## 21.2 `secondary_button.dart`

Utilisation :

* changer photo ;
* aperçu ;
* rejouer ;
* paramètres secondaires.

---

## 21.3 `app_card.dart`

Utilisation :

* cartes difficulté ;
* cartes souvenirs ;
* blocs paramètres.

---

## 21.4 `confirmation_dialog.dart`

Utilisation :

* supprimer un souvenir ;
* supprimer tout l’historique ;
* quitter une partie.

---

## 21.5 `empty_state_widget.dart`

Utilisation :

* aucun souvenir ;
* aucune photo sélectionnée.

---

# 22. Ordre d’implémentation recommandé

## Phase 1 — Setup Flutter

Objectif : créer la base du projet.

Tâches :

* créer projet Flutter ;
* configurer `pubspec.yaml` ;
* créer structure de dossiers ;
* ajouter thème ;
* créer routes ;
* créer widgets boutons ;
* créer Home Screen.

Livrable :

```text
Application qui s’ouvre sur Home Screen.
```

---

## Phase 2 — Parcours photo

Objectif : choisir une photo et l’afficher.

Tâches :

* intégrer `image_picker` ;
* créer PhotoPickerScreen ;
* choisir photo depuis galerie ;
* afficher aperçu ;
* gérer erreur si aucune photo ;
* passer imagePath à DifficultyScreen.

Livrable :

```text
L’utilisateur peut choisir une photo et voir l’aperçu.
```

---

## Phase 3 — Choix difficulté

Objectif : choisir 3x3, 4x4 ou 5x5.

Tâches :

* créer DifficultyScreen ;
* créer enum PuzzleDifficulty ;
* créer cartes de difficulté ;
* passer difficulté à PuzzleScreen.

Livrable :

```text
L’utilisateur peut choisir une difficulté et lancer le jeu.
```

---

## Phase 4 — Puzzle Engine

Objectif : créer la logique pure du puzzle.

Tâches :

* créer PuzzlePiece ;
* créer PuzzleEngine ;
* générer pièces ;
* mélanger pièces ;
* échanger pièces ;
* vérifier victoire ;
* écrire tests unitaires.

Livrable :

```text
Le moteur du puzzle fonctionne sans interface.
```

---

## Phase 5 — Puzzle UI

Objectif : rendre le puzzle jouable.

Tâches :

* créer PuzzleScreen ;
* créer PuzzleBoardWidget ;
* créer PuzzlePieceWidget ;
* afficher les pièces ;
* gérer drag-and-drop ;
* échanger les pièces ;
* compter mouvements ;
* détecter victoire.

Livrable :

```text
Le puzzle est jouable avec une photo.
```

---

## Phase 6 — Timer et victoire

Objectif : finaliser la boucle de jeu.

Tâches :

* ajouter timer ;
* ajouter compteur de mouvements ;
* arrêter timer à la victoire ;
* créer VictoryScreen ;
* ajouter Rejouer ;
* ajouter Nouveau souvenir.

Livrable :

```text
Le joueur peut terminer un puzzle et voir son résultat.
```

---

## Phase 7 — Stockage local

Objectif : sauvegarder les souvenirs.

Tâches :

* ajouter SQLite ;
* créer AppDatabase ;
* créer tables ;
* créer DAO ;
* créer repositories ;
* sauvegarder session ;
* sauvegarder résultat ;
* afficher historique.

Livrable :

```text
Les puzzles terminés apparaissent dans Mes souvenirs.
```

---

## Phase 8 — Suppression et paramètres

Objectif : donner le contrôle à l’utilisateur.

Tâches :

* supprimer un souvenir ;
* supprimer fichiers locaux ;
* créer SettingsScreen ;
* son/vibration activé-désactivé ;
* page confidentialité ;
* supprimer tout l’historique.

Livrable :

```text
L’utilisateur peut gérer ses souvenirs et ses paramètres.
```

---

## Phase 9 — Polish

Objectif : rendre l’application publiable.

Tâches :

* améliorer design ;
* ajouter animations douces ;
* ajouter sons ;
* ajouter vibration ;
* optimiser images ;
* corriger bugs ;
* tester sur appareils Android ;
* créer icône app ;
* préparer Play Store.

Livrable :

```text
MVP Android prêt pour test externe.
```

---

# 23. Sprint plan recommandé

## Sprint 1 — Base app

Durée recommandée : 3 à 5 jours.

Tâches :

* setup Flutter ;
* thème ;
* navigation ;
* Home Screen ;
* boutons réutilisables.

Résultat :

```text
App visuelle de base.
```

---

## Sprint 2 — Photo + difficulté

Durée recommandée : 3 à 5 jours.

Tâches :

* photo picker ;
* aperçu photo ;
* écran difficulté ;
* passage des données entre écrans.

Résultat :

```text
Parcours création puzzle prêt.
```

---

## Sprint 3 — Moteur puzzle

Durée recommandée : 4 à 7 jours.

Tâches :

* modèle pièce ;
* moteur puzzle ;
* mélange ;
* échange ;
* victoire ;
* tests unitaires.

Résultat :

```text
Puzzle logique fonctionnel.
```

---

## Sprint 4 — Gameplay UI

Durée recommandée : 5 à 10 jours.

Tâches :

* puzzle board ;
* affichage pièces ;
* drag-and-drop ;
* timer ;
* mouvements ;
* victoire.

Résultat :

```text
Prototype jouable.
```

---

## Sprint 5 — Données locales

Durée recommandée : 4 à 7 jours.

Tâches :

* SQLite ;
* sessions ;
* résultats ;
* historique ;
* suppression.

Résultat :

```text
MVP local-first.
```

---

## Sprint 6 — Qualité MVP

Durée recommandée : 5 à 10 jours.

Tâches :

* design final ;
* sons ;
* vibrations ;
* optimisation image ;
* gestion erreurs ;
* tests appareils ;
* icône ;
* build release.

Résultat :

```text
Version testable par utilisateurs.
```

---

# 24. Version prototype minimal

Pour aller très vite, le prototype minimal peut ignorer :

* SQLite ;
* historique ;
* paramètres ;
* sons ;
* vibrations ;
* miniatures ;
* optimisation image avancée.

Le prototype minimal doit seulement faire :

```text
Home
Photo Picker
Difficulty
Puzzle 3x3
Drag-and-drop
Victory
```

C’est la meilleure manière de valider rapidement le cœur du jeu.

---

# 25. Version MVP complète

La version MVP complète doit inclure :

```text
Home Screen
Photo Picker
Difficulty Screen
Puzzle Screen
Victory Screen
Memories Screen
Settings Screen
SQLite
Historique local
Suppression souvenir
Timer
Mouvements
Aperçu image
Pause
Confidentialité
```

---

# 26. Priorités de développement

## Must-have

* choix de photo ;
* génération puzzle ;
* déplacement des pièces ;
* détection victoire ;
* écran victoire.

## Should-have

* timer ;
* mouvements ;
* aperçu image ;
* historique ;
* suppression souvenir.

## Could-have

* paramètres ;
* sons ;
* vibrations ;
* animations ;
* mode sombre.

## Won’t-have MVP

* cloud ;
* compte utilisateur ;
* multijoueur ;
* classement ;
* boutique ;
* publicité.

---

# 27. Critères de validation technique

Le projet est validé si :

* l’app démarre sans erreur ;
* l’utilisateur peut choisir une photo ;
* l’utilisateur peut choisir une difficulté ;
* l’image est transformée en puzzle ;
* les pièces sont mélangées ;
* le drag-and-drop fonctionne ;
* le compteur de mouvements augmente ;
* le timer fonctionne ;
* la victoire est détectée ;
* l’écran de victoire apparaît ;
* l’utilisateur peut rejouer ;
* l’utilisateur peut créer un nouveau puzzle ;
* les souvenirs sont sauvegardés localement ;
* l’utilisateur peut supprimer un souvenir ;
* les photos originales ne sont pas supprimées ;
* aucune donnée n’est envoyée vers un serveur.

---

# 28. Risques techniques

## 28.1 Crop des images difficile

Risque :

* les pièces peuvent ne pas afficher la bonne partie de l’image.

Solution :

* commencer avec une méthode simple ;
* tester avec 3x3 ;
* ajouter des tests visuels ;
* garder la grille carrée.

---

## 28.2 Drag-and-drop peu fluide

Risque :

* `Draggable` et `DragTarget` peuvent être limités pour un jeu plus avancé.

Solution :

* utiliser cette méthode pour le MVP ;
* passer plus tard à `GestureDetector` + `Stack` si nécessaire.

---

## 28.3 Photos trop lourdes

Risque :

* crash ou lenteur.

Solution :

* optimiser les images ;
* limiter taille maximale ;
* utiliser une copie locale réduite.

---

## 28.4 Permissions Android/iOS

Risque :

* l’utilisateur refuse l’accès.

Solution :

* message clair ;
* bouton pour réessayer ;
* expliquer que les photos restent locales.

---

# 29. Plan de test manuel MVP

Tester les scénarios suivants :

```text
Créer puzzle facile
Créer puzzle moyen
Créer puzzle difficile
Terminer puzzle
Rejouer puzzle
Créer nouveau souvenir
Voir aperçu image
Mettre en pause
Recommencer
Supprimer souvenir
Refuser accès photo
Choisir image très grande
Choisir image très petite
Fermer et rouvrir app
```

---

# 30. Build Android

Commandes utiles :

```bash
flutter clean
flutter pub get
flutter run
flutter build apk --release
```

Pour tester sur appareil réel :

```bash
flutter devices
flutter run -d device_id
```

---

# 31. Préparation Play Store future

Éléments nécessaires :

* nom de l’application ;
* icône ;
* captures d’écran ;
* description courte ;
* description longue ;
* politique de confidentialité ;
* catégorie jeu puzzle ;
* classification familiale ;
* APK ou AAB release.

Commande future :

```bash
flutter build appbundle --release
```

---

# 32. Résumé final

Souvenir Puzzle doit être développé en commençant par le cœur du gameplay :

```text
Photo → Puzzle → Jeu → Victoire
```

Ensuite seulement, ajouter :

```text
Historique → Paramètres → Sons → Polish → Publication
```

La règle principale :

> Ne pas complexifier avant que le puzzle soit jouable.

La première réussite du projet n’est pas d’avoir toutes les fonctionnalités.
La première réussite est qu’un utilisateur puisse choisir une photo importante, la transformer en puzzle, la terminer et ressentir quelque chose.
