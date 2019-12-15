#!/usr/bin/env bash

# shellcheck disable=SC1091

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Add libraries
source /usr/local/lib/bash-logger.sh
source /usr/local/lib/persist-env.sh


NOTICE "NodeJs version: $(node --version)"
NOTICE "npm version: $(npm --version)"
NOTICE "yarn version: $(yarn --version)"
