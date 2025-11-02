#!/usr/bin/env sh
set -ex

echo "--- HOOK: preup ---"
env | grep AZD || true


echo "preup complete"
