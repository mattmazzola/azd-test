#!/usr/bin/env sh

set -e

echo "--- HOOK: prepackage ---"
env | grep AZURE || true

echo "prepackage complete"
