#!/bin/bash
#
# Generate a database for import in Pantheon.
#
set -e

BASE="$PWD"
cd ./drupal/starter-data
rm -f initial.sql.gz
gzip < initial.sql > initial.sql.gz
cd "$BASE"
rm -rf ./do-not-commit/to-import-in-pantheon/initial.sql.gz
mkdir -p ./do-not-commit/to-import-in-pantheon
mv ./drupal/starter-data/initial.sql.gz ./do-not-commit/to-import-in-pantheon/initial.sql.gz

echo "=> Log into pantheon and import the database:"
echo "=> ./do-not-commit/to-import-in-pantheon/initial.sql.gz"
read -p "Press enter to continue"
rm -f ./do-not-commit/to-import-in-pantheon/initial.sql.gz
echo "=> All done!"
