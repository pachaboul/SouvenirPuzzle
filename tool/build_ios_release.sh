#!/usr/bin/env bash
# Build an App Store IPA for Souvenir Puzzle.
# Prerequisites: Apple Developer account, signing configured in Xcode (Runner target).
set -euo pipefail
cd "$(dirname "$0")/.."

echo "→ Flutter pub get"
flutter pub get

echo "→ iOS app icons"
dart run flutter_launcher_icons

echo "→ Build IPA (release)"
flutter build ipa --release

IPA="build/ios/ipa/souvenir_puzzle.ipa"
if [[ -f "$IPA" ]]; then
  echo ""
  echo "✓ IPA ready: $IPA"
  echo "  Upload with Xcode Organizer or Apple Transporter:"
  echo "  open -a Transporter \"$IPA\""
else
  echo "Build finished — check build/ios/ipa/ for the archive."
fi
