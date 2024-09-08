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
  docker network rm starterkit_drupalsite_default || echo 'docker network cannot be deleted; moving on.'
  rm .env
  echo ""
  echo "-----"
  echo "Your environment has been completely destroyed."
  echo ""
else
  echo ".env file does not exist, which means there is nothing to destroy. Consider running ./scripts/deploy.sh to create a new environment."
fi

rm -f ./drupal/settings/local-settings/unversioned.php
