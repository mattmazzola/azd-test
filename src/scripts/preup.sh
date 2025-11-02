#!/usr/bin/env sh
set -e

echo "--- HOOK: preup ---"
env | grep AZURE || true

echo "preup complete"
