#! /bin/bash

set -ex

echo "Print OS and Tool Versions"
lsb_release -a
az version
az bicep version
azd version
dotnet --version
pwsh --version
docker --version
uv --version
jq --version
gh --version

echo "INSTALLING PROJECT DEPENDENCIES"

# TODO: Add any project specific dependency installation commands here

echo "postStartCommand.sh finished!"
