# Souvenir Puzzle — Database & Data Model Document

Version : 0.1
Projet : Koyra Games
Produit : Souvenir Puzzle
Plateforme MVP : Android
Architecture : Local-first / Offline-first
Base de données recommandée : SQLite avec `sqflite`

---

# 1. Objectif du document

Ce document définit la structure des données locales de **Souvenir Puzzle**.

Il couvre :

* les données à stocker ;
* les données à ne pas stocker ;
* les tables SQLite ;
* les modèles Dart ;
* les DAO ;
* les repositories ;
* les règles de sauvegarde ;
* les règles de suppression ;
* les migrations futures ;
* les principes de confidentialité.

---

# 2. Philosophie des données

Souvenir Puzzle utilise des photos personnelles.
La base de données doit donc respecter trois principes :

1. **Local-first** : les données restent sur le téléphone.
2. **Minimal data** : ne stocker que ce qui est nécessaire.
3. **Privacy by design** : ne jamais envoyer les photos ou données vers un serveur dans le MVP.

Le jeu ne doit pas demander de compte utilisateur pour fonctionner.

---

# 3. Données principales du MVP

Le MVP doit stocker :

* les puzzles créés ;
* les résultats de parties terminées ;
* les meilleurs temps ;
* les meilleurs nombres de mouvements ;
* les miniatures locales ;
* les paramètres simples de l’application.

---

# 4. Données à ne pas stocker

Le MVP ne doit pas stocker :

* nom complet de l’utilisateur ;
* email ;
* numéro de téléphone ;
* localisation GPS ;
* contacts ;
* données biométriques ;
* données cloud ;
* photos envoyées vers un serveur ;
* statistiques publicitaires personnelles.

---

# 5. Stratégie de stockage des images

## 5.1 Photo originale

La photo originale reste dans la galerie du téléphone.

L’application ne doit jamais supprimer la photo originale.

---

## 5.2 Copie optimisée locale

Pour garantir que le puzzle reste rejouable, l’application peut créer une copie optimisée de la photo dans son dossier local.

Chemin recommandé :

```text id="9nxt1l"
app_documents/souvenir_puzzle/images/{session_id}.jpg
```

Cette copie reste uniquement sur l’appareil.

---

## 5.3 Miniature locale

Pour afficher les souvenirs dans l’historique, l’application crée une miniature.

Chemin recommandé :

```text id="9829oj"
app_documents/souvenir_puzzle/thumbnails/{session_id}.jpg
```

---

## 5.4 Règle de suppression

Quand l’utilisateur supprime un souvenir :

* supprimer la ligne `puzzle_sessions` ;
* supprimer les résultats liés ;
* supprimer la copie optimisée locale ;
* supprimer la miniature locale ;
* ne jamais supprimer la photo originale de la galerie.

---

# 6. Vue générale des tables

Le MVP utilise trois tables principales :

```text id="5tmrqq"
puzzle_sessions
puzzle_results
app_settings
```

Tables futures possibles :

```text id="8v5rqo"
albums
badges
app_events
saved_game_states
```

---

# 7. Table `puzzle_sessions`

## 7.1 Rôle

La table `puzzle_sessions` représente un souvenir puzzle créé par l’utilisateur.

Un souvenir puzzle correspond à :

* une photo optimisée ;
* une difficulté ;
* une grille ;
* une date de création ;
* des meilleurs scores.

---

## 7.2 Schéma SQL

```sql id="mvnau5"
CREATE TABLE puzzle_sessions (
  id TEXT PRIMARY KEY,
  original_image_reference TEXT,
  image_path TEXT NOT NULL,
  thumbnail_path TEXT,
  difficulty TEXT NOT NULL,
  rows INTEGER NOT NULL,
  columns INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  last_played_at TEXT,
  is_completed INTEGER NOT NULL DEFAULT 0,
  best_time_seconds INTEGER,
  best_moves INTEGER,
  play_count INTEGER NOT NULL DEFAULT 0,
  deleted_at TEXT
);
```

---

## 7.3 Description des colonnes

| Colonne                  |    Type | Description                                  |
| ------------------------ | ------: | -------------------------------------------- |
| id                       |    TEXT | Identifiant unique de la session             |
| original_image_reference |    TEXT | Référence optionnelle vers l’image originale |
| image_path               |    TEXT | Chemin de la copie optimisée locale          |
| thumbnail_path           |    TEXT | Chemin de la miniature locale                |
| difficulty               |    TEXT | Niveau : easy, medium, hard                  |
| rows                     | INTEGER | Nombre de lignes                             |
| columns                  | INTEGER | Nombre de colonnes                           |
| created_at               |    TEXT | Date de création                             |
| last_played_at           |    TEXT | Dernière date de jeu                         |
| is_completed             | INTEGER | 0 = non terminé, 1 = terminé                 |
| best_time_seconds        | INTEGER | Meilleur temps en secondes                   |
| best_moves               | INTEGER | Meilleur nombre de mouvements                |
| play_count               | INTEGER | Nombre de fois où ce puzzle a été joué       |
| deleted_at               |    TEXT | Date de suppression logique si utilisée      |

---

## 7.4 Remarque sur `deleted_at`

Deux stratégies sont possibles :

### Suppression directe

Supprimer définitivement la ligne.

Avantage :

* simple ;
* propre ;
* moins de données.

### Suppression logique

Remplir `deleted_at` sans supprimer immédiatement la ligne.

Avantage :

* utile pour une corbeille future ;
* utile pour debug.

Recommandation MVP :

```text id="tndnwr"
Suppression directe
```

Donc `deleted_at` peut être retiré du MVP si on veut simplifier.

---

# 8. Table `puzzle_results`

## 8.1 Rôle

La table `puzzle_results` stocke chaque partie terminée.

Un même puzzle peut avoir plusieurs résultats si l’utilisateur le rejoue plusieurs fois.

---

## 8.2 Schéma SQL

```sql id="c85eli"
CREATE TABLE puzzle_results (
  id TEXT PRIMARY KEY,
  puzzle_session_id TEXT NOT NULL,
  completed_at TEXT NOT NULL,
  time_seconds INTEGER NOT NULL,
  moves INTEGER NOT NULL,
  difficulty TEXT NOT NULL,
  rows INTEGER NOT NULL,
  columns INTEGER NOT NULL,
  FOREIGN KEY (puzzle_session_id) REFERENCES puzzle_sessions(id) ON DELETE CASCADE
);
```

---

## 8.3 Description des colonnes

| Colonne           |    Type | Description                    |
| ----------------- | ------: | ------------------------------ |
| id                |    TEXT | Identifiant unique du résultat |
| puzzle_session_id |    TEXT | ID du puzzle lié               |
| completed_at      |    TEXT | Date de fin                    |
| time_seconds      | INTEGER | Temps final en secondes        |
| moves             | INTEGER | Nombre de mouvements           |
| difficulty        |    TEXT | Difficulté utilisée            |
| rows              | INTEGER | Nombre de lignes               |
| columns           | INTEGER | Nombre de colonnes             |

---

# 9. Table `app_settings`

## 9.1 Rôle

La table `app_settings` stocke les préférences simples de l’utilisateur.

---

## 9.2 Schéma SQL

```sql id="jm6s88"
CREATE TABLE app_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

---

## 9.3 Paramètres MVP

| Key                 | Value possible      | Description                        |
| ------------------- | ------------------- | ---------------------------------- |
| language            | system, fr, en, ja  | Langue de l’application            |
| sound_enabled       | true, false         | Son activé ou non                  |
| vibration_enabled   | true, false         | Vibration activée ou non           |
| theme_mode          | light, dark, system | Thème                              |
| privacy_notice_seen | true, false         | Message de confidentialité déjà vu |

---

## 9.4 Valeurs par défaut

```text id="q4747h"
language = system
sound_enabled = true
vibration_enabled = true
theme_mode = light
privacy_notice_seen = false
```

---

# 10. Modèles Dart

---

## 10.1 PuzzleSessionModel

```dart id="6gl2pt"
class PuzzleSessionModel {
  final String id;
  final String? originalImageReference;
  final String imagePath;
  final String? thumbnailPath;
  final String difficulty;
  final int rows;
  final int columns;
  final DateTime createdAt;
  final DateTime? lastPlayedAt;
  final bool isCompleted;
  final int? bestTimeSeconds;
  final int? bestMoves;
  final int playCount;

  PuzzleSessionModel({
    required this.id,
    required this.originalImageReference,
    required this.imagePath,
    required this.thumbnailPath,
    required this.difficulty,
    required this.rows,
    required this.columns,
    required this.createdAt,
    required this.lastPlayedAt,
    required this.isCompleted,
    required this.bestTimeSeconds,
    required this.bestMoves,
    required this.playCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original_image_reference': originalImageReference,
      'image_path': imagePath,
      'thumbnail_path': thumbnailPath,
      'difficulty': difficulty,
      'rows': rows,
      'columns': columns,
      'created_at': createdAt.toIso8601String(),
      'last_played_at': lastPlayedAt?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'best_time_seconds': bestTimeSeconds,
      'best_moves': bestMoves,
      'play_count': playCount,
    };
  }

  factory PuzzleSessionModel.fromMap(Map<String, dynamic> map) {
    return PuzzleSessionModel(
      id: map['id'] as String,
      originalImageReference: map['original_image_reference'] as String?,
      imagePath: map['image_path'] as String,
      thumbnailPath: map['thumbnail_path'] as String?,
      difficulty: map['difficulty'] as String,
      rows: map['rows'] as int,
      columns: map['columns'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastPlayedAt: map['last_played_at'] == null
          ? null
          : DateTime.parse(map['last_played_at'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
      bestTimeSeconds: map['best_time_seconds'] as int?,
      bestMoves: map['best_moves'] as int?,
      playCount: map['play_count'] as int,
    );
  }
}
```

---

## 10.2 PuzzleResultModel

```dart id="64cmos"
class PuzzleResultModel {
  final String id;
  final String puzzleSessionId;
  final DateTime completedAt;
  final int timeSeconds;
  final int moves;
  final String difficulty;
  final int rows;
  final int columns;

  PuzzleResultModel({
    required this.id,
    required this.puzzleSessionId,
    required this.completedAt,
    required this.timeSeconds,
    required this.moves,
    required this.difficulty,
    required this.rows,
    required this.columns,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'puzzle_session_id': puzzleSessionId,
      'completed_at': completedAt.toIso8601String(),
      'time_seconds': timeSeconds,
      'moves': moves,
      'difficulty': difficulty,
      'rows': rows,
      'columns': columns,
    };
  }

  factory PuzzleResultModel.fromMap(Map<String, dynamic> map) {
    return PuzzleResultModel(
      id: map['id'] as String,
      puzzleSessionId: map['puzzle_session_id'] as String,
      completedAt: DateTime.parse(map['completed_at'] as String),
      timeSeconds: map['time_seconds'] as int,
      moves: map['moves'] as int,
      difficulty: map['difficulty'] as String,
      rows: map['rows'] as int,
      columns: map['columns'] as int,
    );
  }
}
```

---

## 10.3 AppSettingModel

```dart id="9ap9q5"
class AppSettingModel {
  final String key;
  final String value;
  final DateTime updatedAt;

  AppSettingModel({
    required this.key,
    required this.value,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AppSettingModel.fromMap(Map<String, dynamic> map) {
    return AppSettingModel(
      key: map['key'] as String,
      value: map['value'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
```

---

# 11. AppDatabase

## 11.1 Rôle

`AppDatabase` initialise SQLite et gère :

* l’ouverture de la base ;
* la création des tables ;
* les migrations ;
* l’accès aux DAO.

---

## 11.2 Exemple de structure

```dart id="9f1gil"
class AppDatabase {
  static const String databaseName = 'souvenir_puzzle.db';
  static const int databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(createPuzzleSessionsTable);
    await db.execute(createPuzzleResultsTable);
    await db.execute(createAppSettingsTable);
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Migrations futures ici.
  }
}
```

---

# 12. DAO — PuzzleSessionDao

## 12.1 Rôle

Le DAO `PuzzleSessionDao` gère les opérations SQL liées aux puzzles.

---

## 12.2 Fonctions nécessaires

```text id="sat77z"
insertSession
getSessionById
getAllSessions
updateSession
updateBestScore
incrementPlayCount
deleteSession
deleteAllSessions
```

---

## 12.3 Exemple

```dart id="s1qpwv"
class PuzzleSessionDao {
  final Database db;

  PuzzleSessionDao(this.db);

  Future<void> insertSession(PuzzleSessionModel session) async {
    await db.insert(
      'puzzle_sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PuzzleSessionModel?> getSessionById(String id) async {
    final result = await db.query(
      'puzzle_sessions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return PuzzleSessionModel.fromMap(result.first);
  }

  Future<List<PuzzleSessionModel>> getAllSessions() async {
    final result = await db.query(
      'puzzle_sessions',
      orderBy: 'created_at DESC',
    );

    return result.map(PuzzleSessionModel.fromMap).toList();
  }

  Future<void> deleteSession(String id) async {
    await db.delete(
      'puzzle_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

---

# 13. DAO — PuzzleResultDao

## 13.1 Rôle

Le DAO `PuzzleResultDao` gère les résultats des parties terminées.

---

## 13.2 Fonctions nécessaires

```text id="moz4z7"
insertResult
getResultsBySessionId
getBestResultByTime
getBestResultByMoves
deleteResultsBySessionId
deleteAllResults
```

---

## 13.3 Exemple

```dart id="a1d7y4"
class PuzzleResultDao {
  final Database db;

  PuzzleResultDao(this.db);

  Future<void> insertResult(PuzzleResultModel result) async {
    await db.insert(
      'puzzle_results',
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PuzzleResultModel>> getResultsBySessionId(
    String sessionId,
  ) async {
    final rows = await db.query(
      'puzzle_results',
      where: 'puzzle_session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'completed_at DESC',
    );

    return rows.map(PuzzleResultModel.fromMap).toList();
  }

  Future<void> deleteResultsBySessionId(String sessionId) async {
    await db.delete(
      'puzzle_results',
      where: 'puzzle_session_id = ?',
      whereArgs: [sessionId],
    );
  }
}
```

---

# 14. DAO — SettingsDao

## 14.1 Rôle

Le DAO `SettingsDao` gère les préférences utilisateur.

---

## 14.2 Fonctions nécessaires

```text id="zeosjr"
getValue
setValue
getAllSettings
resetSettings
```

---

## 14.3 Exemple

```dart id="d8c6zv"
class SettingsDao {
  final Database db;

  SettingsDao(this.db);

  Future<String?> getValue(String key) async {
    final result = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first['value'] as String;
  }

  Future<void> setValue(String key, String value) async {
    await db.insert(
      'app_settings',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
```

---

# 15. Repository — PuzzleRepository

## 15.1 Rôle

Le repository cache les détails SQL au reste de l’application.

L’interface ne doit pas appeler directement les DAO.

---

## 15.2 Fonctions principales

```text id="zyvr2q"
createPuzzleSession
getAllMemories
getPuzzleSession
savePuzzleResult
deleteMemory
deleteAllMemories
updateBestScore
```

---

## 15.3 Logique `savePuzzleResult`

Quand un joueur termine un puzzle :

1. créer un `PuzzleResultModel` ;
2. insérer dans `puzzle_results` ;
3. mettre `is_completed = true` dans `puzzle_sessions` ;
4. mettre à jour `last_played_at` ;
5. incrémenter `play_count` ;
6. comparer le temps avec `best_time_seconds` ;
7. comparer les mouvements avec `best_moves` ;
8. mettre à jour les meilleurs scores si nécessaire.

---

## 15.4 Exemple logique

```dart id="1bxlz9"
Future<void> savePuzzleResult({
  required String sessionId,
  required int timeSeconds,
  required int moves,
  required String difficulty,
  required int rows,
  required int columns,
}) async {
  final session = await sessionDao.getSessionById(sessionId);
  if (session == null) {
    throw Exception('Puzzle session not found');
  }

  final result = PuzzleResultModel(
    id: uuid.v4(),
    puzzleSessionId: sessionId,
    completedAt: DateTime.now(),
    timeSeconds: timeSeconds,
    moves: moves,
    difficulty: difficulty,
    rows: rows,
    columns: columns,
  );

  await resultDao.insertResult(result);

  final newBestTime = session.bestTimeSeconds == null ||
          timeSeconds < session.bestTimeSeconds!
      ? timeSeconds
      : session.bestTimeSeconds;

  final newBestMoves = session.bestMoves == null ||
          moves < session.bestMoves!
      ? moves
      : session.bestMoves;

  final updatedSession = session.copyWith(
    isCompleted: true,
    lastPlayedAt: DateTime.now(),
    bestTimeSeconds: newBestTime,
    bestMoves: newBestMoves,
    playCount: session.playCount + 1,
  );

  await sessionDao.updateSession(updatedSession);
}
```

---

# 16. Repository — SettingsRepository

## 16.1 Rôle

`SettingsRepository` fournit une interface simple pour lire et modifier les paramètres.

---

## 16.2 Fonctions principales

```text id="dl2j54"
isSoundEnabled
setSoundEnabled
isVibrationEnabled
setVibrationEnabled
getThemeMode
setThemeMode
getLanguage
setLanguage
hasSeenPrivacyNotice
setPrivacyNoticeSeen
```

---

# 17. Règles de création d’un souvenir

Quand l’utilisateur crée un puzzle :

1. choisir une photo ;
2. générer un `session_id` ;
3. créer une copie optimisée locale ;
4. créer une miniature locale ;
5. créer une entrée dans `puzzle_sessions` ;
6. ouvrir l’écran de difficulté ;
7. lancer le puzzle.

---

# 18. Règles de sauvegarde d’un résultat

Quand le puzzle est terminé :

1. arrêter le timer ;
2. calculer le temps final ;
3. lire le nombre de mouvements ;
4. créer un résultat ;
5. sauvegarder dans `puzzle_results` ;
6. mettre à jour `puzzle_sessions` ;
7. afficher l’écran de victoire.

---

# 19. Règles de suppression d’un souvenir

Quand l’utilisateur supprime un souvenir :

1. afficher une confirmation ;
2. récupérer la session ;
3. supprimer les résultats liés ;
4. supprimer la session ;
5. supprimer la miniature locale ;
6. supprimer la copie optimisée locale ;
7. rafraîchir la liste des souvenirs.

Message obligatoire :

```text id="73jvtd"
Vos photos originales ne seront pas supprimées de votre téléphone.
```

---

# 20. Règles de suppression de tout l’historique

Quand l’utilisateur supprime tout l’historique :

1. afficher une confirmation forte ;
2. supprimer toutes les lignes de `puzzle_results` ;
3. supprimer toutes les lignes de `puzzle_sessions` ;
4. supprimer toutes les miniatures locales ;
5. supprimer toutes les copies optimisées locales ;
6. conserver les paramètres de l’application ;
7. ne pas supprimer les photos originales.

---

# 21. Gestion des fichiers locaux

## 21.1 Structure recommandée

```text id="r7f9wb"
app_documents/
  souvenir_puzzle/
    images/
      session_id_1.jpg
      session_id_2.jpg

    thumbnails/
      session_id_1.jpg
      session_id_2.jpg
```

---

## 21.2 FileStorageService

Créer un service séparé :

```text id="s8hbv6"
FileStorageService
```

Responsabilités :

* créer les dossiers ;
* sauvegarder une image optimisée ;
* sauvegarder une miniature ;
* supprimer une image ;
* supprimer une miniature ;
* supprimer tous les fichiers locaux ;
* vérifier si un fichier existe.

---

## 21.3 Fonctions nécessaires

```text id="sp6gsd"
saveOptimizedImage
saveThumbnail
deleteImage
deleteThumbnail
deleteAllPuzzleFiles
fileExists
```

---

# 22. Gestion des migrations

## 22.1 Version 1

Tables :

```text id="iivaz3"
puzzle_sessions
puzzle_results
app_settings
```

---

## 22.2 Migration future vers version 2

Exemples possibles :

* ajouter albums ;
* ajouter tags ;
* ajouter sauvegarde des puzzles non terminés ;
* ajouter badges ;
* ajouter statistiques globales.

---

## 22.3 Exemple migration version 2

```sql id="0l9xew"
ALTER TABLE puzzle_sessions ADD COLUMN album_id TEXT;
```

---

## 22.4 Règle de migration

Toute migration doit :

* préserver les souvenirs existants ;
* éviter de supprimer les images locales ;
* être testée avant publication ;
* garder une possibilité de récupération en cas d’erreur.

---

# 23. Table future `albums`

## 23.1 Rôle

Dans une version future, les utilisateurs pourront organiser leurs souvenirs par album.

Exemples :

* Famille ;
* Voyage ;
* Mariage ;
* Village ;
* Enfants ;
* Amis.

---

## 23.2 Schéma futur possible

```sql id="ifnrry"
CREATE TABLE albums (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  cover_thumbnail_path TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

---

# 24. Table future `saved_game_states`

## 24.1 Rôle

Sauvegarder une partie non terminée.

---

## 24.2 Schéma futur possible

```sql id="hde2ek"
CREATE TABLE saved_game_states (
  id TEXT PRIMARY KEY,
  puzzle_session_id TEXT NOT NULL,
  piece_positions TEXT NOT NULL,
  elapsed_time_seconds INTEGER NOT NULL,
  moves INTEGER NOT NULL,
  saved_at TEXT NOT NULL,
  FOREIGN KEY (puzzle_session_id) REFERENCES puzzle_sessions(id) ON DELETE CASCADE
);
```

---

## 24.3 Format `piece_positions`

Stocker en JSON :

```json id="j0fldb"
[
  {"pieceId": "piece_0", "currentIndex": 4},
  {"pieceId": "piece_1", "currentIndex": 2},
  {"pieceId": "piece_2", "currentIndex": 0}
]
```

---

# 25. Table future `badges`

## 25.1 Rôle

Ajouter des récompenses douces.

---

## 25.2 Schéma futur possible

```sql id="wy7u0y"
CREATE TABLE badges (
  id TEXT PRIMARY KEY,
  badge_key TEXT NOT NULL,
  unlocked_at TEXT NOT NULL
);
```

Exemples de badges :

```text id="xonm3l"
first_memory
ten_puzzles_completed
family_memory
travel_memory
puzzle_without_preview
```

---

# 26. Index recommandés

Pour améliorer les performances :

```sql id="l04005"
CREATE INDEX idx_puzzle_sessions_created_at
ON puzzle_sessions(created_at);

CREATE INDEX idx_puzzle_results_session_id
ON puzzle_results(puzzle_session_id);

CREATE INDEX idx_puzzle_results_completed_at
ON puzzle_results(completed_at);
```

---

# 27. Transactions

Certaines opérations doivent être atomiques.

## 27.1 Sauvegarder un résultat

Cette opération doit utiliser une transaction :

* insérer le résultat ;
* mettre à jour la session ;
* mettre à jour les meilleurs scores.

Si une partie échoue, tout doit être annulé.

---

## 27.2 Supprimer un souvenir

Cette opération doit être prudente.

Ordre recommandé :

1. lire les chemins fichiers ;
2. supprimer les lignes SQL dans une transaction ;
3. supprimer les fichiers locaux ;
4. si suppression fichier échoue, logger l’erreur mais ne pas crasher.

---

# 28. Gestion des erreurs données

## 28.1 Session introuvable

Cas :

* l’utilisateur essaie de rejouer un puzzle supprimé ;
* la base contient une référence cassée.

Réponse :

```text id="z3a4q3"
Ce souvenir n’est plus disponible.
```

---

## 28.2 Image locale introuvable

Cas :

* fichier supprimé manuellement ;
* nettoyage système ;
* erreur de stockage.

Réponse :

```text id="8xpl5s"
L’image de ce souvenir est introuvable.
Vous pouvez supprimer ce souvenir ou créer un nouveau puzzle.
```

---

## 28.3 Base de données inaccessible

Réponse :

```text id="dta0ar"
Impossible de charger vos souvenirs pour le moment.
Veuillez réessayer.
```

---

# 29. Tests des données

## 29.1 Tests unitaires DAO

Tester :

* insertion session ;
* lecture session ;
* mise à jour session ;
* suppression session ;
* insertion résultat ;
* lecture résultats ;
* suppression résultats ;
* lecture paramètres ;
* modification paramètres.

---

## 29.2 Tests repository

Tester :

* création souvenir ;
* sauvegarde résultat ;
* mise à jour meilleur temps ;
* mise à jour meilleurs mouvements ;
* suppression souvenir ;
* suppression historique complet.

---

## 29.3 Tests fichiers

Tester :

* création dossier images ;
* création dossier thumbnails ;
* sauvegarde image optimisée ;
* sauvegarde miniature ;
* suppression image ;
* suppression miniature ;
* comportement si fichier absent.

---

# 30. Données de démonstration

Pour tester l’application sans galerie, on peut ajouter quelques images locales de test en mode développement.

Attention :

Ces images ne doivent pas être incluses comme souvenirs personnels d’utilisateurs.

---

# 31. Résumé de la base MVP

## Tables MVP

```text id="f1ficn"
puzzle_sessions
puzzle_results
app_settings
```

## Données principales

```text id="0pqiie"
photo optimisée locale
miniature locale
difficulté
temps
mouvements
meilleurs scores
paramètres
```

## Principe central

```text id="wgt5xd"
Les souvenirs restent sur le téléphone.
```

---

# 32. Définition de “Done” pour la couche données

La couche données est terminée quand :

* la base SQLite s’initialise correctement ;
* les tables sont créées ;
* une session peut être créée ;
* un résultat peut être sauvegardé ;
* les meilleurs scores sont mis à jour ;
* les souvenirs peuvent être listés ;
* un souvenir peut être supprimé ;
* tout l’historique peut être supprimé ;
* les fichiers locaux associés sont supprimés ;
* les photos originales ne sont jamais supprimées ;
* les paramètres sont sauvegardés et relus correctement.

---

# 33. Résumé final

La base de données de Souvenir Puzzle doit rester simple, locale et fiable.

Le MVP n’a besoin que de trois tables :

1. `puzzle_sessions`
2. `puzzle_results`
3. `app_settings`

La logique importante n’est pas seulement technique.
Elle est aussi éthique :

> L’utilisateur joue avec ses souvenirs personnels.
> Ses photos doivent rester privées, locales et sous son contrôle.
