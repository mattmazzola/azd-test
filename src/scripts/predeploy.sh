#!/usr/bin/env sh
set -ex

echo "--- HOOK: predeploy ---"
echo "About to run azd deploy steps"
env | grep AZD || true


echo "predeploy complete"
