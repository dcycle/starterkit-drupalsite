#!/bin/bash
#
# Migrate data from your local site to Acquia (see ./README.md).
#
set -e

DIR="$(pwd)"

if [ -z "$1" ]; then
  >&2 echo "Please specify an environment from the following list:"
  ls -lah ./config/acquia
  exit 1;
fi
CONFIGDIR="./config/acquia/$1"
if [ ! -d "$CONFIGDIR" ]; then
  >&2 echo "$CONFIGDIR does not exist :("
  exit 1;
fi

source ./scripts/lib/load-config.source.sh

if [ -z "$ACQUIA_USER" ]; then
  >&2 echo "Please define ACQUIA_USER in $CONFIGDIR"
  exit 1
fi
if [ -z "$ACQUIA_SERVER" ]; then
  >&2 echo "Please define ACQUIA_SERVER in $CONFIGDIR"
  exit 1
fi

echo '[info] Dumping our local database to the Docker container'
docker compose exec -T drupal /bin/bash -c 'drush sql-dump > /db.sql'

echo '[info] Copying our database from our local container to our computer'
docker cp $(docker compose ps -q drupal):/db.sql ./do-not-commit/db.sql

echo '[info] Compressing our database'
cd "$DIR"/do-not-commit && tar -czvf db.sql.tar.gz db.sql && cd "$DIR"

echo '[info] Copying our compressed database to the stage server'
scp ./do-not-commit/db.sql.tar.gz "$ACQUIA_USER@$ACQUIA_SERVER":db.sql.tar.gz

echo '[info] Decompressing the db on our stage server'
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  'tar xzvf db.sql.tar.gz'

echo '[info] Completely deleting everything on the stage server'
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  "drush @$ACQUIA_USER si -y standard"

echo '[info] Importing the db on our stage server'
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  "drush @$ACQUIA_USER sqlc < db.sql"

echo '[info] Running our update procedure on the stage server'
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  "drush @$ACQUIA_USER updb -y"
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  "drush @$ACQUIA_USER config:import -y --source=../config"
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  "drush @$ACQUIA_USER cr"
ssh "$ACQUIA_USER@$ACQUIA_SERVER" \
  "drush @$ACQUIA_USER cron"
