#!/usr/bin/env sh

set -e

echo "--- HOOK: postpackage ---"
env | grep AZURE || true

echo "postpackage complete"
