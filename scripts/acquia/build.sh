#!/bin/bash
#
# Build the Acquia code from our code.
# Acquia requires downloaded code (core, modules...) and, in some cases but not # necessarily always, generated code (css from sass...) to be in its git
# repo. We download these in Docker containers when we run ./scripts/deploy.sh.
# This script translates our code to code Acquia expects.
#
set -e

echo '=> Remembering the present working directory.'

BASEPWD="$(pwd)"
echo "It is $BASEPWD"

echo '=> Building code for Acquia.'

echo '=> Start with a preflight to make sure we have all required information.'

source ./scripts/acquia/lib/load-config.source.sh

echo '=> Making sure all tests pass before we build. To skip this run:'
echo '=>'
echo '=> export ACQUIA_SKIP_TEST_DEPLOY=1'
echo '=>'

if [ "$ACQUIA_SKIP_TEST_DEPLOY" != "1" ]; then
  ./scripts/test.sh
fi

echo '=> Deploying our local environment. To skip this run:'
echo '=>'
echo '=> export ACQUIA_SKIP_TEST_DEPLOY=1'
echo '=>'

if [ "$ACQUIA_SKIP_TEST_DEPLOY" != "1" ]; then
  ./scripts/deploy.sh
fi

echo "=> Pulling the latest changes and tags for the Acquia site"
cd "$ACQUIAGIT" && git reset --hard && git clean -df && git pull origin master --tags

echo "=> Making sure we are on the master branch"
cd "$ACQUIAGIT" && git checkout master

echo "=> Copying drupal root and config from our repo to docroots on Acquia"
echo "=> repos."
echo "=> Creating $ACQUIAGIT/temporary-build-info to keep track of the sites"
echo "=> folder which might contain data from other multisite sites."

rm -rf "$ACQUIAGIT"/temporary-build-info
mkdir "$ACQUIAGIT"/temporary-build-info/
echo "=> Moving ./sites to $ACQUIAGIT/temporary-build-info/sites."
mv "$ACQUIAGIT"/docroot/sites "$ACQUIAGIT"/temporary-build-info/sites
ls -lah "$ACQUIAGIT"/temporary-build-info/sites

echo "=> Entirely remove ./docroot, we will replace it with a fresh"
echo "=> version of what is in our Docker container."
rm -rf "$ACQUIAGIT"/docroot

echo "=> Preparing to copy drupal root from container..."
cd "$BASEPWD" && docker-compose exec -T drupal /bin/bash -c "chmod u+w sites/$ACQUIA_MULTISITE_ID"

echo "=> Copying docroot to ./temporary-build-info..."
docker cp $(cd "$BASEPWD" && docker-compose ps -q drupal):/var/www/html "$ACQUIAGIT"/temporary-build-info
ls "$ACQUIAGIT"/temporary-build-info
echo "=> Moving docroot from ./temporary-build-info... to ./docroot"
mkdir "$ACQUIAGIT"/docroot
# See https://askubuntu.com/questions/259383/how-can-i-get-mv-or-the-wildcard-to-move-hidden-files
shopt -s dotglob
mv "$ACQUIAGIT"/temporary-build-info/html/* "$ACQUIAGIT"/docroot
ls "$ACQUIAGIT"/docroot

echo "=> Updating our multisite-specific info to $ACQUIA_MULTISITE_ID"
rm -rf "$ACQUIAGIT"/temporary-build-info/sites/"$ACQUIA_MULTISITE_ID"
if [ -f "$ACQUIAGIT"/temporary-build-info/sites/sites.php ]; then
  rm -rf "$ACQUIAGIT"/temporary-build-info/sites/sites.php
fi
mv "$ACQUIAGIT"/docroot/sites/"$ACQUIA_MULTISITE_ID" "$ACQUIAGIT"/temporary-build-info/sites/"$ACQUIA_MULTISITE_ID"
SITEDIR="$ACQUIAGIT"/temporary-build-info/sites/"$ACQUIA_MULTISITE_ID"
echo "SITEDIR=$SITEDIR"
ls "$SITEDIR"
if [ -f "$ACQUIAGIT"/docroot/sites/sites.php ]; then
  mv "$ACQUIAGIT"/docroot/sites/sites.php "$ACQUIAGIT"/temporary-build-info/sites/sites.php
fi

echo "=> Bring all multisite info back to ./docroot/sites"
rm -rf "$ACQUIAGIT"/docroot/sites
mv "$ACQUIAGIT"/temporary-build-info/sites "$ACQUIAGIT"/docroot/sites
ls "$ACQUIAGIT"/docroot/sites

echo "=> Remove ./temporary-build-info"
rm -rf "$ACQUIAGIT"/temporary-build-info

echo "=> Copying drupal config from container..."
rm -rf "$ACQUIAGIT"/config
docker cp $(cd "$BASEPWD" && docker-compose ps -q drupal):/var/www/$ACQUIA_CONFIG_DIR "$ACQUIAGIT"/config
mkdir -p "$ACQUIAGIT/$ACQUIA_CONFIG_DIR"/default
touch "$ACQUIAGIT/$ACQUIA_CONFIG_DIR"/default/.gitkeep

echo "=> Determining build tag"
cd "$BASEPWD"
TAG=`date +%Y-%m-%d-%H-%M-%S-%Z-`$(git rev-parse --short HEAD)"-"$RANDOM
echo "Build tag is $TAG"

cd "$ACQUIAGIT"
git add .
git commit -am "Updated to build $TAG (do not modify this repo manually, see README)" | true
git tag "$TAG"
git push origin master --tags

echo "=> Everything seems up to date, see ./README.md for details."
cd "$BASEPWD"
echo "The build tag is:"
echo " ==> $TAG"
