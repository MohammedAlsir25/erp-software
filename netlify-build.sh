#!/bin/bash
set -e

# Download and extract Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.0-stable.tar.xz -O flutter_sdk.tar.xz
tar xf flutter_sdk.tar.xz
export PATH="$PATH:$PWD/flutter/bin"

# Verify Flutter installation
flutter --version

# Configure project for web (if not already)
flutter create . --platforms web

# Get dependencies
flutter pub get

# Build for web
flutter build web
