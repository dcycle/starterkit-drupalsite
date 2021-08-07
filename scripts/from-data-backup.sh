#!/bin/bash
#
# Restores a previous data backup.
#
set -e

BASEDIR=./do-not-commit/data-dumps
echo "Data backups are stored in $BASEDIR"

if [ ! -d "$BASEDIR" ]; then
  >&2 echo "$BASEDIR does not exist."
  >&2 echo "Try using ./scripts/create-data-backup.sh"
  >&2 echo "to create your first backup."
  exit 1
fi

echo "Available backups are:"
ls -lah "$BASEDIR"

if [ -z "$1" ]; then
  >&2 echo "Please use an argument such as YYYY-MM-DD-12345"
  exit 1
fi

COMPRESSEDFILE="$BASEDIR/$1.tar.gz"

if [ ! -f "$COMPRESSEDFILE" ]; then
  >&2 echo "$COMPRESSEDFILE does not exist."
  exit 1
fi

echo "Start by creating an emergency rollback data backup..."
./scripts/create-data-backup.sh "$1-rollback"

echo "Rollback done. Restoring from $1..."
TARBALL="$1.tar.gz"

echo "We are in $BASEDIR"
echo "$TARBALL should exist"

if [ ! -f "./do-not-commit/data-dumps/$TARBALL" ]; then
  >&2 echo "It does not seem to :("
  ls -lah
  exit 1
else
  echo "It does, moving on..."
fi

echo "Extracting it..."
FULLDIRONCONTAINER="/do-not-commit/data-dumps/$1"
FULLDIRONLOCAL=".$FULLDIRONCONTAINER"
./scripts/docker-compose.sh exec drupal /bin/bash -c "cd /do-not-commit/data-dumps && tar xzvf $TARBALL"
echo "It is extracted."
echo "On the container it is at $FULLDIRONCONTAINER"
echo "On local it is at $FULLDIRONLOCAL"

echo "$FULLDIRONLOCAL should exist."


if [ ! -d "$FULLDIRONLOCAL" ]; then
  >&2 echo "Something went wrong, it does not seem to exist."
  exit 1
else
  echo "It does, moving on..."
fi

echo "Performing a clean install..."
./scripts/docker-compose.sh exec drupal /bin/bash -c "drush si -y"
echo "Grabbing the sql database..."
./scripts/docker-compose.sh exec drupal /bin/bash -c "drush sqlc < $FULLDIRONCONTAINER/db.sql"
echo "Grabbing public files..."
./scripts/docker-compose.sh exec drupal /bin/bash -c "cp -r $FULLDIRONCONTAINER/files/* /var/www/html/sites/default/files/"
echo "Grabbing private files..."
./scripts/docker-compose.sh exec drupal /bin/bash -c "cp -r $FULLDIRONCONTAINER/drupal-private-files/* /drupal-private-files/"

echo "Removing $FULLDIRONCONTAINER because he have its compressed version"
echo "already (saves disk space)..."
rm -rf "$FULLDIRONCONTAINER"

echo "Running a deployment, this sets the correct file perms, imports config..."
./scripts/deploy.sh

echo "All done importing a backup."
echo ""
echo " => $1 has been imported (and $1-rollback has been saved with your previous version)"
echo ""
