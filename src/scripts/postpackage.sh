#!/usr/bin/env sh

set -ex

echo "--- HOOK: postpackage ---"
echo "Package step finished"
env | grep AZD || true


echo "postpackage complete"
