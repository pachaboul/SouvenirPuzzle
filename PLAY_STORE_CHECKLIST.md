# Google Play — Release Checklist (Souvenir Puzzle)

## 1. Create the upload keystore (you run this; keep the passwords private)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then create `android/key.properties` (copy from `android/key.properties.example`):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/hassanexirg/upload-keystore.jks
```

⚠️ Back up `upload-keystore.jks` and the passwords somewhere safe. If you lose
them you can't update the app (unless you use Play App Signing key reset).
`key.properties` and `*.jks` are already git-ignored.

## 2. Build the App Bundle (AAB — required by Play)

```bash
flutter clean
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

Verify it is NOT debug-signed:
```bash
# Should show your CN, not "Android Debug"
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

Bump `version:` in `pubspec.yaml` for each upload (versionCode must increase).

## 3. Privacy policy (required — app accesses photos)

Host `PRIVACY_POLICY.md` at a public URL, e.g. GitHub Pages:
`https://pachaboul.github.io/SouvenirPuzzle/privacy` (or any host). Put that URL
in Play Console → App content → Privacy policy.

## 4. Play Console store listing

- **App name:** Souvenir Puzzle
- **Short description** (≤80 chars): e.g. "Turn your photos into calm, family
  jigsaw puzzles — fully offline."
- **Full description:** features (photo → puzzle, 5–9 levels, progression,
  stats, FR/EN, offline, privacy).
- **Graphics:**
  - App icon 512×512 (PNG)
  - Feature graphic 1024×500
  - Phone screenshots (min 2; capture Home / Puzzle / Victory / Memories / Stats)
- **Category:** Games → Puzzle
- **Content rating:** complete the questionnaire (no violence, no ads → likely
  PEGI 3 / Everyone)
- **Data safety:** declare **no data collected / no data shared** (true here)
- **Target audience & content:** choose age groups; no ads
- **Countries / pricing:** free

## 5. Internal testing → production

Upload the AAB to an **Internal testing** track first, install via the opt-in
link on a real device, verify everything, then promote to Production.

## Status of code-side items
- [x] Release signing config wired to `key.properties` (`android/app/build.gradle.kts`)
- [x] `url_launcher` `<queries>` added to AndroidManifest (email/PayPal open on Android 11+)
- [x] Branded adaptive launcher icon
- [x] targetSdk current (Flutter 3.32 → API 35)
- [ ] Keystore created + `key.properties` filled (your step)
- [ ] AAB built & signed with upload key (after keystore)
- [ ] Privacy policy hosted
- [ ] Store listing + graphics + Data safety in Play Console
