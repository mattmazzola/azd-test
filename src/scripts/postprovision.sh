#!/usr/bin/env sh

set -e

echo "--- HOOK: postprovision ---"
env | grep AZURE || true


echo "postprovision complete"
