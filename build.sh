#!/bin/bash

# Exit on error
set -e

# Install Flutter SDK
echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Enable Flutter web
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the web version
flutter build web
