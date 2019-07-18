#!/bin/sh

set -x
set -e
set -o pipefail

# flutter version
flutter doctor

# dependencies
## flutter get
flutter packages get

# Code Analysis
## flutter dartfmt
flutter dartfmt --set-exit-if-changed lib/* | awk '/Formatted/ { print $0 }'

# Clear flutter analyze result
rm -rf ~/.dartServer/.analysis-driver/

## flutter analyze
flutter analyze

# Test
## flutter test
flutter test

## flutter driver test
## Required to run simulator
flutter drive --target=test_driver/app.dart
