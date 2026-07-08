# Captures d'écran — Souvenir Puzzle

Images générées automatiquement pour le Play Store, le site ou la communication.

## Structure

| Dossier | Contenu |
|---------|---------|
| `app-store/6.7-inch/fr/` | **App Store** 6,7" — **1290×2796** px (6 écrans) |
| `fr/light/` | Marketing / Play Store — 412×915 px |
| `fr/dark/` | Français, thème sombre |
| `en/light/` | Anglais, thème clair |

**App Store (6,7")** : accueil, souvenirs, stats, difficulté, puzzle, victoire.

**Marketing (412×915)** : splash, accueil, souvenirs, stats, paramètres, guide, difficulté, puzzle, victoire.

## Régénérer

```bash
chmod +x tool/capture_screenshots.sh
./tool/capture_screenshots.sh
```

Ou uniquement App Store 6,7" :

```bash
flutter test test/app_store_screenshots_test.dart --update-goldens
```

Les données affichées (profil « Marie », statistiques, souvenirs) sont des **données de démo** définies dans `test/fixtures/screenshot_demo_data.dart`.

## Captures sur émulateur (optionnel)

Pour des captures depuis l’app réelle sur Android :

```bash
flutter emulators --launch Medium_Phone_API_36
flutter test integration_test/screenshots_test.dart -d Medium_Phone_API_36
```

Les fichiers apparaissent dans `build/integration_test_screenshots/`.
