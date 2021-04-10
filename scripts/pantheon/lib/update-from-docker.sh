#!/bin/bash
#
# Move Items from Docker to Pantheon.
#
set -e

echo "=> About to copy code from Docker to Pantheon"
echo "=> Removing core from pantheon git"
rm -rf ./do-not-commit/pantheon/core
echo "=> Removing vendor from pantheon git"
rm -rf ./do-not-commit/pantheon/vendor
echo "=> Removing modules from pantheon git"
rm -rf ./do-not-commit/pantheon/modules
echo "=> Removing themes from pantheon git"
rm -rf ./do-not-commit/pantheon/themes
echo "=> Removing config from pantheon git"
rm -rf ./do-not-commit/pantheon/sites/default/config

echo "=> Moving from docker to pantheon"
echo "=> Moving core"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/html/core ./do-not-commit/pantheon/core
echo "=> Moving vendor"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/html/vendor ./do-not-commit/pantheon/vendor
echo "=> Moving modules"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/html/modules ./do-not-commit/pantheon/modules
echo "=> Moving themes"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/html/themes ./do-not-commit/pantheon/themes
echo "=> Moving config"
docker cp $(./scripts/docker-compose.sh ps -q drupal):/var/www/config ./do-not-commit/pantheon/sites/default/config
