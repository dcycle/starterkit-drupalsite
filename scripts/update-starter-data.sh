#!/bin/bash
#
# Make the starter database correspond to what's on your environment.
#
set -e

echo " => "
echo " => Updating the database at ./drupal/starter-data/initial.sql"
echo " => from the live database."
echo " => "

echo " => Truncating cache tables for a smaller footprint."
docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c 'echo "show tables" | drush sqlc | grep cache_ | xargs -I {} echo "truncate {};" | drush sqlc'
echo " => Updating starter db."
docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c 'drush sql-dump' > ./drupal/starter-data/initial.sql
echo "[info] Adding newline between , and ( making it easier to read code diffs."
# shellcheck disable=SC1004
sed -i -e 's/,(/,\
(/g' ./drupal/starter-data/initial.sql
rm ./drupal/starter-data/initial.sql-e
echo " => Done updating starter db."

echo " => "
echo " => Updating the files at ./drupal/starter-data/files from live files on" echo " => the container."
echo " => "
rm -rf ./drupal/starter-data/files
docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c 'cp -r /var/www/html/sites/default/files /starter-data/files'
docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c 'rm -rf /starter-data/files/css /starter-data/files/js /starter-data/files/php /starter-data/files/styles /starter-data/files/.htaccess'
