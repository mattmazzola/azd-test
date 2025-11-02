#!/usr/bin/env sh

set -ex


echo "--- HOOK: postprovision ---"
echo "AZURE outputs available (sample):"
echo "AZURE_APP_URL: ${AZURE_APP_URL:-<unset>}"
echo "AZURE_RESOURCE_GROUP: ${AZURE_RESOURCE_GROUP:-<unset>}"
env | grep AZURE || true


echo "postprovision complete"
