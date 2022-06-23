#!/bin/bash
#
# Create a database backup.
#
set -e

if [ -z "$1" ]; then
  echo "No argument was passed to $BASH_SOURCE so we will derive a"
  echo "dirname from ./scripts/lib/data-unique-dirname.sh."
  DIRNAME="$(./scripts/lib/data-unique-dirname.sh)"
else
  echo "Using the argument passed to $BASH_SOURCE"
  echo "as a dirname."
  DIRNAME="$1"
fi

echo "Using dirname $DIRNAME"

FULLDIRONCONTAINER="/do-not-commit/data-dumps/$DIRNAME"
FULLDIRONLOCAL=".$FULLDIRONCONTAINER"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "rm -rf $FULLDIRONCONTAINER"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "mkdir -p $FULLDIRONCONTAINER"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "drush sql-dump > $FULLDIRONCONTAINER/db.sql"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "cp -r /var/www/html/sites/default/files $FULLDIRONCONTAINER"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "cp -r /drupal-private-files $FULLDIRONCONTAINER"

./scripts/docker-compose.sh exec -T drupal /bin/bash -c "cd /do-not-commit/data-dumps && tar -czvf $DIRNAME.tar.gz $DIRNAME && rm -rf $DIRNAME"

echo "All done exporting a backup."
echo ""
echo " => $FULLDIRONLOCAL.tar.gz"
echo ""
