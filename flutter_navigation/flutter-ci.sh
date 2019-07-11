#!/bin/sh

set -x
set -e
set -o pipefail

# flutter version
flutter --version

# dependencies
## flutter get
flutter packages get

# Code Analysis
## flutter dartfmt
flutter dartfmt --set-exit-if-changed lib/*

## flutter analyze
flutter analyze

# Test
## flutter test
flutter test

## flutter driver test
## Required to run simulator
flutter drive --target=test_driver/app.dart