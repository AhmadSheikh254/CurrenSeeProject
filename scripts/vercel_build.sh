#!/usr/bin/env bash
# Vercel build script for CurrenSee (Flutter web).
# Installs the Flutter SDK (cached between builds) and produces build/web.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_DIR="${VERCEL_CACHE_DIR:-$HOME/.cache}/flutter"

if [ ! -d "$FLUTTER_DIR/bin" ]; then
  echo "Cloning Flutter ($FLUTTER_VERSION)..."
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --no-analytics --enable-web
flutter pub get
flutter build web --release

echo "Build complete: build/web"
