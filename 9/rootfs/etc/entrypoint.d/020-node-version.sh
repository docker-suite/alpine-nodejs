#!/bin/sh

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

echo 'NodeJs version:' $(node --version)
echo 'npm version:' $(npm --version)
echo 'yarn version:' $(yarn --version)
