#!/bin/bash
#
# Get unique login links for pantheon environments.
#
set -e

./scripts/pantheon/drush.sh dev uli
