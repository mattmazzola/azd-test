#!/usr/bin/env sh
set -e

echo "--- HOOK: predeploy ---"
env | grep AZURE || true

echo "predeploy complete"
