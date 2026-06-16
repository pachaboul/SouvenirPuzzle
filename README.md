# Souvenir Puzzle

> Turn your photos into puzzles and relive your memories piece by piece.

**Souvenir Puzzle** is a simple, calm, family-friendly mobile game by **Koyra Games**. The player picks a photo from their phone, chooses a difficulty, and rebuilds the image piece by piece. Every puzzle is a personal memory — family, children, weddings, trips, friends, important moments — brought back to life as a quiet, interactive experience.

- **Type:** Photo-puzzle casual game
- **Platform (MVP):** Android — iOS planned for a future release
- **Tech:** Flutter / Dart
- **Architecture:** Local-first / offline-first (no backend)
- **Privacy:** Photos never leave the device

---

## 📥 Download (Android)

**[Download the latest APK (v1.0.0)](https://github.com/pachaboul/SouvenirPuzzle/releases/download/v1.0.0/souvenir-puzzle-v1.0.0.apk)** — ~21 MB.

On your Android phone: open the link, download the APK, then allow installation from unknown sources when prompted. All releases are listed on the [Releases page](https://github.com/pachaboul/SouvenirPuzzle/releases).

---

## Vision

Souvenir Puzzle is more than a puzzle game. Many people have thousands of photos on their phone but rarely look at them. This game gives those photos a new life by turning them into a gentle, emotional activity that the whole family can enjoy — children, parents, couples, seniors, the diaspora, and casual players alike.

---

## Core gameplay loop

1. Open the app and tap **Create a puzzle**.
2. Pick a photo from the gallery and preview it.
3. Choose a difficulty.
4. The photo is automatically sliced into a shuffled grid.
5. Drag pieces to swap them and rebuild the image.
6. The game detects victory automatically.
7. See the victory screen (final time + moves), then replay or start a new memory.

### Difficulty levels

| Level  | Grid  | Audience                       |
| ------ | ----- | ------------------------------ |
| Easy   | 3 × 3 | Children, seniors, beginners   |
| Medium | 4 × 4 | Casual players                 |
| Hard   | 5 × 5 | More patient players           |

### Game mechanic

Drag-and-drop swap: the player drags a piece onto another position; if that slot is occupied, the two pieces swap places. The puzzle is solved when every piece is back in its correct position. A move counter and a timer run during play, with **pause** and **preview original image** options to help along the way.

---

## MVP scope

**Included**

- Home screen
- Photo selection from gallery + preview
- Difficulty selection
- Automatic puzzle generation (resize → slice → shuffle)
- Drag-and-drop gameplay
- Timer and move counter
- Pause and full-image preview
- Victory detection + victory screen
- Simple local history ("Mes souvenirs")
- Simple settings + local privacy

**Not included**

User accounts, mandatory login, cloud sync, social sharing, multiplayer, online leaderboards, ads, premium store, complex puzzle shapes, AI, collaborative albums.

---

## Tech stack

- **Framework:** Flutter (Dart, SDK `^3.8.1`)
- **State management:** [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- **Photo picking:** [`image_picker`](https://pub.dev/packages/image_picker)
- **Local storage:** [`sqflite`](https://pub.dev/packages/sqflite) + [`path`](https://pub.dev/packages/path) + [`path_provider`](https://pub.dev/packages/path_provider)
- **IDs:** [`uuid`](https://pub.dev/packages/uuid)
- **Icons:** [`cupertino_icons`](https://pub.dev/packages/cupertino_icons)

### Data model

- **PuzzleSession** — `id`, `imageReference`, `thumbnailPath`, `difficulty`, `rows`, `columns`, `createdAt`, `lastPlayedAt`, `isCompleted`, `bestTimeSeconds`, `bestMoves`
- **PuzzleResult** — `id`, `puzzleSessionId`, `completedAt`, `timeSeconds`, `moves`, `difficulty`
- **AppSettings** — `language`, `soundEnabled`, `vibrationEnabled`, `themeMode`, `privacyAccepted`

---

## Planned project structure

The implementation follows a feature-first layout (see [docs](#documentation)):

```
lib/
  main.dart
  app/            # app entry, router, theme, constants
  core/           # errors, utils, shared widgets, services
  data/           # local DB (sqflite), models, DAOs, repositories
  features/
    home/
    photo_picker/
    difficulty/
    puzzle/       # domain (engine, pieces), application, presentation
    memories/
    settings/
```

> **Current status:** playable with local persistence. Home → photo picker → difficulty → drag-and-drop puzzle (timer, moves, preview, pause) → victory, plus a **"Mes souvenirs"** history backed by SQLite (`sqflite`, FFI on desktop): each memory keeps a local optimized copy + thumbnail, tracks best time / moves / play count, and can be replayed or deleted (original gallery photo never touched). Still to come: settings (sound/vibration/theme/privacy), sounds & haptics, and FR/EN localization.

---

## Getting started

Prerequisites: the [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.8.1`) and an Android device or emulator.

```bash
# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Run tests
flutter test
```

---

## Privacy

Souvenir Puzzle is built **privacy-by-design**:

- Photos and data stay on the device — nothing is uploaded.
- No user account is required to play.
- The user can delete their local history at any time.
- Permissions are requested and explained clearly.

---

## Documentation

Full design documentation lives in [`docs_souvernirpuzzle/`](docs_souvernirpuzzle/):

- [Product Requirements Document](docs_souvernirpuzzle/Product%20Requirements%20Document.md)
- [Game Design Document](docs_souvernirpuzzle/Game%20Design%20Document.md)
- [Technical Specification Document](docs_souvernirpuzzle/Technical%20Specification%20Document.md)
- [UI UX Design Document](docs_souvernirpuzzle/UI%20UX%20Design%20Document.md)
- [Database & Data Model Document](docs_souvernirpuzzle/Database%20&%20Data%20Model%20Document.md)
- [Flutter Project Structure & Implementation Plan](docs_souvernirpuzzle/Flutter%20Project%20Structure%20&%20Implementation%20Plan.md)
- [Development Document](docs_souvernirpuzzle/Development%20Document.md)

---

© Koyra Games — Souvenir Puzzle (v0.1, MVP in development)
