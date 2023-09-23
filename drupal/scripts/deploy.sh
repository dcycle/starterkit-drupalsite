#!/bin/bash
#
# This script is run when the Drupal docker container is ready. It prepares
# an environment for development or testing, which contains a full Drupal
# 8 installation with a running website and our custom modules.
#
set -e

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  >&2 echo 'MYSQL_ROOT_PASSWORD should always be set; please destroy your'
  >&2 echo 'environment using "docker compose down -v", then restart it'
  >&2 echo 'using ./scripts/deploy.sh, which should create a password in'
  >&2 echo 'the ./.env file.'
  exit 2;
fi

echo "Will try to connect to MySQL container until it is up. This can take up to 15 seconds if the container has just been spun up."
OUTPUT="ERROR"
TRIES=15
for i in `seq 1 "$TRIES"`;
do
  OUTPUT=$(echo 'show databases'|{ mysql -h mysql -u root --password="$MYSQL_ROOT_PASSWORD" 2>&1 || true; })
  if [[ "$OUTPUT" == *"ERROR"* ]]; then
    if [ "$i" == "$TRIES" ];then
      echo "MySQL container after $TRIES tries, with error $OUTPUT. Abandoning. We suggest you reset Docker to factory defaults, then give Docker 6Gb instead of 2Gb RAM in the Resources section of the preferences pane, and try again. If you are still getting an error please open a ticket at https://github.com/dcycle/starterkit-drupalsite/issues with this message and any other information about your environment."
      exit 1
    else
      echo "Try $i of $TRIES. MySQL container is not available yet. Should not be long..."
      sleep 1
    fi
  else
    echo "MySQL is up! Moving on..."
    break
  fi
done

OUTPUT=$(echo 'select * from users limit 1'|{ mysql --user=root --password="$MYSQL_ROOT_PASSWORD" --database=drupal --host=mysql 2>&1 || true; })
if [[ "$OUTPUT" == *"ERROR"* ]]; then
  echo "Using starter data because we did not find an entry in the users table."
  echo "Installing the starter database..."
  drush sqlc < /starter-data/initial.sql
  if [ -d /starter-data/files ]; then
    echo "Instaling the starter files such as images..."
    cp -r /starter-data/files/* /var/www/html/sites/default/files/
  fi
  if [ -d /starter-data/private-files ]; then
    echo "Instaling the starter private files"
    cp -r /starter-data/private-files/* /drupal-private-files/
  fi
  echo "Done installing starter data."
  /scripts/update-config-in-code-if-updb-modifies-config-in-db.sh
else
  echo "Assuming Drupal is already running, because there is a users table with at least one entry."
fi
/scripts/prep-file-directory.sh \
  /var/www/html/sites/default/files \
  /scripts/public-htaccess-file.txt
/scripts/prep-file-directory.sh \
  /drupal-private-files

# Copy all items from /drupal-modules-contrib and /drupal-themes-contrib to
# modules/contrib and themes/contrib.
# See comments in ./docker-resources/drupal/build-drupal.sh for more details.
if [ -d /drupal-modules-contrib ]; then
  cp -r /drupal-modules-contrib/* modules/contrib/
  cp -r /drupal-themes-contrib/* themes/contrib/
  rm -rf /drupal-modules-contrib /drupal-themes-contrib
fi
