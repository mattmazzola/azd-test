#!/bin/bash
set -e

echo "--- HOOK: postup ---"
env | grep AZURE || true

echo "Post Up"
