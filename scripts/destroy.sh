#!/bin/bash
#
# Destroy the current environment if possible.
#
set -e

if [ -f "./.env" ]; then
  source .env
  TARGET_ENV=$CURRENT_TARGET_ENV
  echo "Destroying environment of type $TARGET_ENV."
  source ./scripts/lib/destroy.source.sh
  docker network rm starterkit_drupal8site_default
  rm .env
else
  echo ".env file does not exist, which means there is nothing to destroy. Consider running ./scripts/deploy.sh to create a new environment."
fi
