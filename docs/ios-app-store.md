# Publication App Store — Souvenir Puzzle

Guide pour publier **Souvenir Puzzle** sur l'App Store iOS.

## Prérequis

| Élément | Détail |
|---------|--------|
| Compte Apple Developer | [developer.apple.com](https://developer.apple.com) — 99 USD/an |
| Mac + Xcode | Déjà installé (Xcode 26+) |
| Bundle ID | `com.koyragames.souvenir_puzzle` (aligné Android) |
| Version actuelle | `1.2.1` (build `4`) — `pubspec.yaml` |

## 1. Créer l'app dans App Store Connect

1. [App Store Connect](https://appstoreconnect.apple.com) → **Apps** → **+** → Nouvelle app
2. Plateforme : **iOS**
3. Nom : **Souvenir Puzzle**
4. Langue principale : **Français**
5. Bundle ID : `com.koyragames.souvenir_puzzle` (à enregistrer d'abord dans [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list))
6. SKU : ex. `souvenir-puzzle-ios`

## 2. Configurer la signature (une fois)

1. Ouvrir le projet iOS dans Xcode :
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Cible **Runner** → **Signing & Capabilities**
3. Cocher **Automatically manage signing**
4. Choisir votre **Team** (compte Apple Developer)
5. Vérifier le Bundle Identifier : `com.koyragames.souvenir_puzzle`

## 3. Build et upload

### Option A — Script Flutter (recommandé)

```bash
chmod +x tool/build_ios_release.sh
./tool/build_ios_release.sh
```

L'IPA est généré dans `build/ios/ipa/souvenir_puzzle.ipa`.

### Option B — Xcode

1. **Product** → **Archive**
2. **Distribute App** → **App Store Connect** → Upload

### Upload de l'IPA

- App **Transporter** (Mac App Store) : glisser-déposer l'IPA
- Ou via Xcode Organizer après Archive

## 4. Fiche App Store (App Store Connect)

À préparer avant soumission :

### Textes (FR + EN conseillé)

- **Nom** : Souvenir Puzzle
- **Sous-titre** (30 car.) : ex. « Puzzles photo souvenirs »
- **Description** : reprendre le pitch du README (photos locales, profils, stats, timer…)
- **Mots-clés** : puzzle, photo, souvenir, famille, mémoire, jeu
- **URL support** : page contact / GitHub issues
- **URL politique de confidentialité** : obligatoire (même une page simple expliquant que les photos restent sur l'appareil)

### Captures d'écran

**App Store 6,7"** (1290 × 2796 px) — prêtes à l'emploi :

`screenshots/app-store/6.7-inch/fr/` (accueil, souvenirs, stats, difficulté, puzzle, victoire)

Tailles requises (iPhone) :

| Appareil | Résolution | Statut |
|----------|------------|--------|
| 6,7" (14/15 Pro Max…) | 1290 × 2796 | ✅ généré |
| 6,5" (11 Pro Max…) | 1242 × 2688 | redimensionner si besoin |
| 5,5" (8 Plus…) | 1242 × 2208 | optionnel |

Captures marketing plus petites : `screenshots/fr/light/` (412×915).

### Politique de confidentialité (obligatoire)

URL à renseigner dans App Store Connect :

**https://pachaboul.github.io/SouvenirPuzzle/privacy/**

(Fichiers dans `docs/privacy/` — activer GitHub Pages sur la branche `main`, dossier `/docs`.)

### Classification

- **Catégorie** : Jeux → Puzzle (ou Famille)
- **Âge** : 4+ (pas de contenu sensible)
- **Chiffrement** : Non (`ITSAppUsesNonExemptEncryption = false` déjà dans Info.plist)

### Confidentialité (App Privacy)

Déclarer :

- **Photos** : accès pour fonctionnalité de l'app, **non liées à l'identité**, **non utilisées pour le suivi**
- Pas de collecte de données personnelles vers des serveurs (app 100 % locale)

## 5. Test avant publication

### Sur votre iPhone (déjà connecté)

```bash
flutter run --release
```

### TestFlight (bêta recommandée)

1. Après upload, App Store Connect → **TestFlight**
2. Ajouter des testeurs internes
3. Valider sur appareil réel (photos, profils, puzzle, timer, thème clair/sombre)

## 6. Soumission review

1. App Store Connect → votre version → **+** build (sélectionner le build uploadé)
2. Remplir export compliance (chiffrement : Non)
3. **Soumettre pour examen**

Délai habituel : 24–48 h.

## Checklist technique (déjà fait dans le repo)

- [x] Projet `ios/` Flutter
- [x] Bundle ID `com.koyragames.souvenir_puzzle`
- [x] Nom affiché « Souvenir Puzzle »
- [x] Permission galerie (`NSPhotoLibraryUsageDescription`)
- [x] Déclaration chiffrement export
- [x] Icônes iOS (`flutter_launcher_icons`)
- [x] iOS minimum 13.0

## Prochaines étapes côté vous

1. Compte Apple Developer actif
2. **Installer iOS 26.5** dans Xcode → **Settings** → **Components** (requis pour builder avec Xcode 26 et un iPhone en iOS 26)
3. Enregistrer le Bundle ID sur developer.apple.com
4. Configurer la signature dans Xcode (étape 2)
5. Lancer `./tool/build_ios_release.sh` et uploader l'IPA
6. Remplir la fiche App Store + politique de confidentialité
7. TestFlight puis soumission

### Dépannage build

Si vous voyez `iOS 26.5 is not installed` :

1. Ouvrir **Xcode** → **Settings** → **Components**
2. Télécharger **iOS 26.5** (plateforme + support appareil)
3. Relancer `flutter build ipa --release` ou `./tool/build_ios_release.sh`
