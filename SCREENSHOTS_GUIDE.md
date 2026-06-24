# Screenshots & graphics guide (Play Store)

## Requirements
- **Phone screenshots:** 2–8 images, PNG/JPG, portrait recommended.
  Use **1080 × 1920** (9:16). Min side 320, max 3840.
- **Feature graphic:** **1024 × 500** PNG/JPG (no transparency). Shown at the top
  of the listing.
- **App icon:** 512 × 512 PNG (you already have the in-app adaptive icon; export
  a 512² version for the listing).

## Which screens to capture (suggested 6)
1. **Home** — logo, title, Create / Play (the aurora look).
2. **Difficulty chooser** — shows the 9 levels + progression/locks.
3. **Puzzle in progress** — a recognizable photo mid-solve (timer + moves).
4. **Victory** — "Félicitations !" with time/moves.
5. **My memories** — the photo grid gallery.
6. **Statistics** — the dashboard.

Tip: add 1–2 family-friendly demo photos first so the puzzle/memories/victory
screens look great. Avoid personal/private photos in store images.

## How to capture (real device — best quality)
```bash
# Plug in an Android phone (USB debugging on), then:
flutter run --release          # run the polished build
# Navigate to each screen, and for each one:
adb exec-out screencap -p > screenshot_home.png
```
Repeat per screen (rename each file). 1080×1920-class phones give the right size.

## How to capture (emulator)
```bash
flutter emulators --launch <id>     # e.g. a Pixel 6 (1080×2400) image
flutter run --release
# Use the emulator's camera/screenshot button, or:
adb exec-out screencap -p > screenshot_home.png
```

## Feature graphic (1024×500)
Quick approach: a 1024×500 canvas with the **Bleu Nuit → aurora** background,
the logo + "Souvenir Puzzle" in gold, and the tagline
"Chaque pièce raconte une histoire." Tools: Canva, Figma, or any image editor.

## Optional: framed / captioned screenshots
For a more "pro" listing you can place the raw screenshots inside phone frames
with a short caption each (e.g. "Vos photos en puzzles", "9 niveaux",
"100% hors-ligne"). Tools: https://screenshots.pro, https://www.appstorescreenshot.com,
or Figma templates.
