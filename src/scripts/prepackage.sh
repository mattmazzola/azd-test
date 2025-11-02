#!/usr/bin/env sh

set -ex

echo "--- HOOK: prepackage ---"
echo "Packaging step (build context)"
env | grep AZD || true


echo "prepackage complete"
