#!/usr/bin/env sh

set -ex

echo "--- HOOK: preprovision ---"
echo "PWD: $(pwd)"
echo "ENV: ${AZURE_ENV_NAME:-<unset>}"
echo "RG: ${AZURE_RESOURCE_GROUP:-<unset>}"
env | grep AZD || true


echo "preprovision complete"
