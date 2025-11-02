#!/usr/bin/env sh

set -e

echo "--- HOOK: preprovision ---"
env | grep AZURE || true


echo "preprovision complete"
