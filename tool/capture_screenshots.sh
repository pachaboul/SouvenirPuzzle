#!/usr/bin/env bash
# Generate store/marketing screenshots from golden widget tests.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "→ Generating phone screenshots (412×915)…"
flutter test test/screenshot_goldens_test.dart --update-goldens

echo "→ Generating App Store 6,7\" screenshots (1290×2796)…"
flutter test test/app_store_screenshots_test.dart --update-goldens

echo ""
echo "✓ Screenshots saved under screenshots/"
find screenshots -name '*.png' | sort
