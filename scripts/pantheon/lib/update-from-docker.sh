#!/bin/bash
#
# Move Items from Docker to Pantheon.
#
set -e

echo "=> About to copy code from Docker to Pantheon"
echo "=> Removing modules from pantheon git"
rm -rf ./do-not-commit/pantheon/web/modules
echo "=> Removing themes from pantheon git"
rm -rf ./do-not-commit/pantheon/web/themes
echo "=> Removing config from pantheon git"
rm -rf ./do-not-commit/pantheon/config

echo "=> Moving from docker to pantheon"
echo "=> Moving modules"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/html/modules ./do-not-commit/pantheon/web/modules
echo "=> Moving themes"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/html/themes ./do-not-commit/pantheon/web/themes
echo "=> Moving config"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/config ./do-not-commit/pantheon/web/config
